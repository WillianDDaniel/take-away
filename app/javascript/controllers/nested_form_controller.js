import { Controller } from "@hotwired/stimulus"

let index = 0

export default class extends Controller {
  static targets = ["template", "container"]

  add(event) {
    event.preventDefault()
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, (index + 1).toString())
    this.containerTarget.insertAdjacentHTML('beforeend', content)
    index++
  }

  remove(event) {
    event.preventDefault()
    const wrapper = event.target.closest('.tag-fields')
    wrapper.remove()
    index--
  }
}