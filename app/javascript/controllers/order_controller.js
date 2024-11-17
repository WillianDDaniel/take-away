// app/javascript/controllers/order_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["orderItems"]

  addItem(event) {
    event.preventDefault()
    const itemName = event.params.itemName
    const portionId = event.params.portionId
    const portionDescription = event.params.portionDescription
    const portionPrice = event.params.portionPrice

    const itemDiv = document.createElement("div")
    itemDiv.classList.add(
      "flex", "items-center", "justify-between",
      "space-x-2", "bg-white", "p-3", "rounded",
      "shadow-sm"
    )

    itemDiv.id = `order_portion_${portionId}`

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
    }).format(portionPrice / 100);
    nameLabel.innerHTML = `${itemName} <br> ${portionDescription} - R$ ${formattedPrice}`
    itemDiv.appendChild(nameLabel)

    const quantityField = document.createElement("input")
    quantityField.type = "number"
    quantityField.name = "order[order_items_attributes][][quantity]"
    quantityField.min = 1
    quantityField.value = 1
    quantityField.classList.add(
      "w-16", "border", "border-gray-300", "rounded", "text-center"
    )
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
    removeButton.addEventListener("click", () => itemDiv.remove())
    itemDiv.appendChild(removeButton)

    this.orderItemsTarget.appendChild(itemDiv)
  }
}