import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar"]

  toggleButton() {
    this.sidebarTarget.classList.toggle('-translate-x-full');
  }
}