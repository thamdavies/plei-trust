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
}
