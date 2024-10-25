import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['openTime', 'closeTime', 'checkbox']

  connect() {
    this.openTimeTargets.forEach((target) => {
      target.setAttribute('readonly', true)
    })

    this.closeTimeTargets.forEach((target) => {
      target.setAttribute('readonly', true)
    })
  }

  toggle(event) {
    const checkbox = event.target
    const index = checkbox.dataset.index

    // Filtrar pelos targets que correspondem ao índice correto
    const openTimeField = this.openTimeTargets.find(el => el.dataset.index === index)
    const closeTimeField = this.closeTimeTargets.find(el => el.dataset.index === index)

    if (checkbox.checked) {
      // Se o checkbox está marcado, tornar os campos editáveis
      openTimeField.removeAttribute('readonly')
      closeTimeField.removeAttribute('readonly')
    } else {
      // Se o checkbox está desmarcado, tornar os campos readonly
      openTimeField.setAttribute('readonly', true)
      closeTimeField.setAttribute('readonly', true)
      closeTimeField.value = ''
      openTimeField.value = ''
    }
  }
}
