import { Controller } from '@hotwired/stimulus';
import SlimSelect from 'slim-select';

export default class extends Controller {
  static targets = ['select'];

  static values = { selected: Array | String };

  connect() {
    this.initSelectSlim();
  }

  disconnect() {
    if (this.slimSelectIns) this.slimSelectIns.destroy();
  }

  initSelectSlim() {
    this.slimSelectIns = new SlimSelect({
      select: this.selectTarget,
      settings: {
        placeholderText: this.selectTarget.getAttribute('placeholder') || 'Chọn',
        searchPlaceholder: 'Tìm kiếm',
        searchText: 'Không có kết quả',
        hideSelected: true,
      },
    });
    if (typeof this.selectedValue === 'string') {
      this.slimSelectIns.setSelected([this.selectedValue]);
    } else if (Array.isArray(this.selectedValue)) {
      this.slimSelectIns.setSelected(this.selectedValue.map(String));
    }
  }
}
