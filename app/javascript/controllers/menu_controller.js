// menu_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["nav"]

  connect() {
    console.log("Menu controller connected!") // << add this
  }

  toggle() {
    console.log("Toggled!")
    this.navTarget.classList.toggle("hidden")
  }
}
