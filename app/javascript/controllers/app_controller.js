import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="app"
export default class extends Controller {
	static targets = [
		"sidebar",
		"sidebarBackdrop",
		"toggleSidebarMobileHamburger",
		"toggleSidebarMobileClose",
		"toggleSidebarMobile",
		"toggleSidebarMobileSearch"
	];

	toggleSidebarMobile() {
		this.sidebarTarget.classList.toggle('hidden');
		this.sidebarBackdropTarget.classList.toggle('hidden');
		this.toggleSidebarMobileHamburgerTarget.classList.toggle('hidden');
		this.toggleSidebarMobileCloseTarget.classList.toggle('hidden');
	}

	redirectToUrl(event) {
		const url = event.currentTarget.dataset.url;
		window.location.href = url;
	}

	printPage() {
		const printableElement = document.querySelector('#printable');

		if (printableElement) {
			const url = printableElement.dataset.url;
			const separator = url.includes('?') ? '&' : '?';
			window.open(`${url}${separator}printable=true`, 'popup', 'width='+screen.width + 'height='+screen.height).print();
		}
	}
}
