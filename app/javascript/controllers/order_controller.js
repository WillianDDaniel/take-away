import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["orderItems", "total"]
  static values = {
    items: { type: Array, default: [] }
  }

  connect() {
    this.calculateTotal()
  }

  addItem(event) {
    event.preventDefault()
    const itemName = event.params.itemName
    const portionId = event.params.portionId
    const portionDescription = event.params.portionDescription
    const portionPrice = event.params.portionPrice

    const alreadySelected = document.getElementById(`selected_portion_${portionId}`)
    if (alreadySelected) {
      const quantityField = alreadySelected.querySelector("input[name='order[order_items_attributes][][quantity]']")
      quantityField.value = parseInt(quantityField.value) + 1
      this.calculateTotal()
      return
    }

    const itemDiv = document.createElement("div")
    itemDiv.classList.add(
      "flex", "items-center", "justify-between",
      "space-x-2", "bg-white", "p-3", "rounded",
      "shadow-sm"
    )

    itemDiv.id = `selected_portion_${portionId}`
    itemDiv.dataset.price = portionPrice

    const portionField = document.createElement("input")
    portionField.type = "hidden"
    portionField.name = "order[order_items_attributes][][portion_id]"
    portionField.value = portionId
    itemDiv.appendChild(portionField)

    const nameLabel = document.createElement("div")
    nameLabel.classList.add("text-gray-800", "flex-grow", "text-sm")
    let formattedPrice = new Intl.NumberFormat('pt-BR', {
      style: 'currency',
      currency: 'BRL',
      minimumFractionDigits: 2,
      maximumFractionDigits: 2
    }).format(portionPrice / 100)

    nameLabel.innerHTML = `${itemName} <br> ${portionDescription} - ${formattedPrice}`
    itemDiv.appendChild(nameLabel)

    const quantityField = document.createElement("input")
    quantityField.type = "number"
    quantityField.name = "order[order_items_attributes][][quantity]"
    quantityField.min = 1
    quantityField.value = 1
    quantityField.classList.add(
      "w-16", "border", "border-gray-300", "rounded", "text-center"
    )

    quantityField.addEventListener("change", () => this.calculateTotal())
    itemDiv.appendChild(quantityField)

    const noteField = document.createElement("input")
    noteField.type = "text"
    noteField.name = "order[order_items_attributes][][note]"
    noteField.placeholder = "Observações"
    noteField.classList.add("w-40", "border", "border-gray-300", "rounded", "px-2")
    itemDiv.appendChild(noteField)

    const removeButton = document.createElement("button")
    removeButton.type = "button"
    removeButton.textContent = "Remover"
    removeButton.classList.add("text-red-600", "hover:underline", "ml-2")
    removeButton.addEventListener("click", () => {
      itemDiv.remove()
      this.calculateTotal()
    })
    itemDiv.appendChild(removeButton)

    this.orderItemsTarget.appendChild(itemDiv)
    this.calculateTotal()
  }

  removeItem(event) {
    event.preventDefault()
    const itemDiv = event.target.closest("div")
    itemDiv.remove()
    this.calculateTotal()
  }

  calculateTotal() {
    let total = 0
    const items = this.orderItemsTarget.querySelectorAll("[id^='selected_portion_']")

    items.forEach(item => {
      const price = parseInt(item.dataset.price)
      const quantity = parseInt(item.querySelector("input[type='number']").value)
      total += price * quantity
    })

    const formattedTotal = new Intl.NumberFormat('pt-BR', {
      style: 'currency',
      currency: 'BRL',
      minimumFractionDigits: 2,
      maximumFractionDigits: 2
    }).format(total / 100)

    this.totalTarget.textContent = `Total: ${formattedTotal}`
  }
}