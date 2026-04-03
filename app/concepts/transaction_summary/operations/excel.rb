module TransactionSummary::Operations
  class Excel < ApplicationOperation
    step Subprocess(TransactionSummary::Operations::Index)
    step :build_workbook

    def build_workbook(ctx, transaction_summary:, model:, total_amount_in:, total_amount_out:, **)
      transactions = model.decorate

      # Estimate display width: Vietnamese/multibyte chars ≈ 2 units, ASCII ≈ 1
      ew = ->(v) { v.to_s.each_char.sum { |c| c.bytesize > 1 ? 2 : 1 } }

      # Format number as it appears in the cell (e.g. 1,234,567) for width calc
      fmt_num = ->(v) { v.to_d == 0 ? "0" : v.to_d.abs.to_i.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\1,').reverse }

      summary_categories = [
        [ "Cầm Đồ",        transaction_summary.pawn ],
        [ "Trả Góp",       transaction_summary.installment ],
        [ "Thu Hoạt Động", transaction_summary.income ],
        [ "Chi Hoạt Động", transaction_summary.expense ],
        [ "Nguồn Vốn",     transaction_summary.capital ]
      ]

      # Pre-build detail rows for width calculation (string values)
      detail_str_rows = transactions.each_with_index.map do |item, i|
        [
          (i + 1).to_s,
          item.transactable_type_name,
          item.contract_code,
          item.asset_name,
          item.transaction_by,
          item.customer_name,
          item.transaction_date.to_s,
          item.description,
          fmt_num.(item.amount_in.to_d * 1_000),
          fmt_num.(item.amount_out.to_d * 1_000),
          item.notes
        ]
      end

      detail_header = [ "STT", "Loại hình", "Mã HĐ", "Tài sản", "Người GD",
                        "Khách hàng", "Ngày GD", "Diễn Giải", "Đã Thu", "Đã Chi", "Ghi chú" ]

      # Summary section col widths (4 cols, padded to 11 with nils for max comparison)
      summary_str_rows = [
        [ "Loại hình giao dịch", "Thu", "Chi", "Tổng cộng" ],
        [ "Tiền đầu ngày", "-", "-", fmt_num.(transaction_summary.opening_balance) ],
        *summary_categories.map { |(lbl, amt)| [ lbl, fmt_num.(amt.amount_in), fmt_num.(amt.amount_out), fmt_num.(amt.difference) ] },
        [ "Tiền mặt còn lại", "-", "-", fmt_num.(transaction_summary.remaining_cash) ]
      ]

      all_str_rows = summary_str_rows.map { |r| r + Array.new(7) } +
                     [ detail_header ] + detail_str_rows

      col_widths = (0..10).map do |ci|
        w = all_str_rows.map { |r| ew.(r[ci]) }.max.to_i + 4
        [ w, 6 ].max
      end

      ctx[:workbook] = Axlsx::Package.new do |p|
        wb = p.workbook
        s  = wb.styles

        vc = { vertical: :center }
        title_s   = s.add_style b: true, sz: 13, alignment: vc
        section_s = s.add_style b: true, sz: 11, alignment: vc
        header_s  = s.add_style b: true, bg_color: "DBEAFE", fg_color: "1E3A8A",
                                 alignment: { horizontal: :center, vertical: :center, wrap_text: true },
                                 border: { style: :thin, color: "93C5FD" }
        normal_s  = s.add_style num_fmt: 3, alignment: vc
        blue_s    = s.add_style fg_color: "1D4ED8", num_fmt: 3, alignment: vc
        red_s     = s.add_style fg_color: "DC2626", num_fmt: 3, alignment: vc
        bold_s    = s.add_style b: true, num_fmt: 3, alignment: vc
        bblue_s   = s.add_style b: true, fg_color: "1D4ED8", num_fmt: 3, alignment: vc
        bred_s    = s.add_style b: true, fg_color: "DC2626", num_fmt: 3, alignment: vc
        date_s    = s.add_style format_code: "DD/MM/YYYY", alignment: vc
        right_s   = s.add_style b: true, alignment: { horizontal: :right, vertical: :center }

        sign_blue = ->(v) { v.to_d >= 0 ? bblue_s : bred_s }

        wb.add_worksheet(name: "Tổng hợp giao dịch") do |ws|
          # ─── Section 1: Summary ───────────────────────────────
          ws.add_row [ "BẢNG TỔNG KẾT GIAO DỊCH" ], style: title_s, height: 30
          ws.merge_cells "A1:D1"

          ws.add_row [ "Loại hình giao dịch", "Thu", "Chi", "Tổng cộng" ],
                     style: [ header_s, header_s, header_s, header_s ], height: 26

          ws.add_row [ "Tiền đầu ngày", nil, nil, transaction_summary.opening_balance ],
                     style: [ normal_s, normal_s, normal_s, sign_blue.(transaction_summary.opening_balance) ], height: 22

          summary_categories.each do |(label, amt)|
            ws.add_row [ label, amt.amount_in, amt.amount_out, amt.difference ],
                       style: [ normal_s, blue_s, red_s, sign_blue.(amt.difference) ], height: 22
          end

          ws.add_row [ "Tiền mặt còn lại", nil, nil, transaction_summary.remaining_cash ],
                     style: [ bold_s, normal_s, normal_s, sign_blue.(transaction_summary.remaining_cash) ], height: 22

          ws.add_row [], height: 10

          # ─── Section 2: Detail ───────────────────────────────
          ws.add_row [ "CHI TIẾT GIAO DỊCH" ], style: section_s, height: 30
          ws.merge_cells "A11:K11"

          ws.add_row detail_header, style: Array.new(11, header_s), height: 26

          transactions.each_with_index do |item, i|
            ain  = item.amount_in.to_d  * 1_000
            aout = item.amount_out.to_d * 1_000
            ws.add_row [
              i + 1,
              item.transactable_type_name,
              item.contract_code,
              item.asset_name,
              item.transaction_by,
              item.customer_name,
              item.transaction_date,
              item.description,
              ain,
              aout,
              item.notes
            ], style: [ normal_s, normal_s, normal_s, normal_s, normal_s,
                        blue_s,   date_s,   normal_s, blue_s,   red_s,    normal_s ],
               types: [ :integer, :string,  :string,  :string,  :string,
                        :string,  :date,    :string,  :float,   :float,   :string ],
               height: 22
          end

          ws.add_row [ "", "", "", "", "", "", "", "Tổng:", total_amount_in, total_amount_out, "" ],
                     style: [ normal_s, normal_s, normal_s, normal_s, normal_s,
                               normal_s, normal_s, right_s,  bblue_s,  bred_s,   normal_s ],
                     height: 24

          ws.column_widths(*col_widths)
        end
      end
    end
  end
end
