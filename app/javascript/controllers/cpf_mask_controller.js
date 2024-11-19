import { Controller } from "@hotwired/stimulus";
import Inputmask from "inputmask";

export default class extends Controller {
  static targets = ["cpf"];

  connect() {
    const cpfIM = new Inputmask.default("999.999.999-99", {
      clearMaskOnLostFocus: true,
      placeholder: "_",
      removeMaskOnSubmit: true,
    });
    cpfIM.mask(this.cpfTarget);
  }
}
