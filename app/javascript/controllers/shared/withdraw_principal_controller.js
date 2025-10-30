import { Controller } from "@hotwired/stimulus";
import { FetchRequest } from '@rails/request.js';
import { alertController } from "../../alert";

// Connects to data-controller="shared--withdraw-principal"
export default class extends Controller {
  static targets = [
    "oldDebtText",
    "interestAmountText",
    "otherAmountInput",
    "totalAmountText",
    "transactionDateInput"
  ];

  connect() {
    console.log("Connected to withdraw principal controller");
  }

  async calculateInterestByDays() {
    try {
      const contractId = document.getElementById("withdraw_principal_contract_id").value;
      let url = "/contracts/withdraw_principals/" + contractId + "?transaction_date=" + this.transactionDateInputTarget.value;
      url += "&other_amount=" + this.otherAmountInputTarget.value;

      const request = new FetchRequest('GET', url, {
        responseKind: 'json',
      });

      const { response } = await request.perform();

      if (response.ok) {
        const data = await response.json();
        this.oldDebtTextTarget.textContent = data.old_debt_amount;
        this.interestAmountTextTarget.textContent = `${data.interest_amount} (${data.days_count} ngày)`;
        this.otherAmountInputTarget.value = data.other_amount.replace(' VNĐ', '');
        this.totalAmountTextTarget.textContent = data.total_amount;
        console.log(data);
      } else {
        throw new Error('Something went wrong');
      }
    } catch (error) {
      console.error(error);
      alertController.show('Không thể tính lãi theo ngày', 'alert');
    }
  }
}