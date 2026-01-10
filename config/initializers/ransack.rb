Ransack.configure do |config|
  config.add_predicate "dt_equals",
    arel_predicate: "eq",
    formatter: proc { |v| v.to_date },
    validator: proc { |v| v.present? },
    type: :string

  config.add_predicate "dt_gteq",
    arel_predicate: "gteq",
    formatter: proc { |v| v.to_date },
    validator: proc { |v| v.present? },
    type: :string

  config.add_predicate "dt_lteq",
    arel_predicate: "lteq",
    formatter: proc { |v| v.to_date },
    validator: proc { |v| v.present? },
    type: :string
end
