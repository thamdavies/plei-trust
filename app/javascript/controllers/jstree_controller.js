import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['tree'];

  static values = { plugins: Array };

  connect() {
    if (this.treeTarget) {
      this.initTree();
      setTimeout(() => {
        $('.jstree').removeClass('hidden');
        $('#spinner').addClass('hidden');
      }, 500);
    }
  }

  initTree() {
    const plugins = this.pluginsValue || [];

    $(this.treeTarget).jstree({
      plugins: plugins,
    });
  }
}
