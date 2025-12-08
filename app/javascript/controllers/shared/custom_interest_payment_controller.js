import { Controller } from "@hotwired/stimulus";
import { FetchRequest } from '@rails/request.js';
import { addDays, format } from "date-fns";
import { alertController } from "../../alert";

// Connects to data-controller="shared--custom-interest-payment"
export default class extends Controller {
  static targets = [
    "fromDateInput",
    "toDateInput", 
    "nextInterestDate",
    "daysCountInput",
    "interestAmount",
    "otherAmountInput",
    "interestAmountInput",
    "totalInterestAmount",
    "totalInterestAmountInput",
    "customerPaymentAmountInput"
  ]

  resetForm() {
    console.log("Resetting form");
  }

  setToValidDate() {
    const fromDate = this.#fromDate();
    const toDate = this.#toDate();

    if (toDate < fromDate) {
      console.log('Resetting toDate to fromDate');
      this.toDateInputTarget.value = this.fromDateInputTarget.value;
    }
  }

  setToDateValue() {
    let daysCount = this.daysCountInputTarget.value;
    if (daysCount === "" || isNaN(daysCount) || parseInt(daysCount) <= 0) {
      this.daysCountInputTarget.value = 1;
      daysCount = 1;
    }

    // format is dd/mm/yyyy
    const fromDate = this.fromDateInputTarget.value;
    const fromDateParts = fromDate.split('/');
    const formattedFromDate = `${fromDateParts[2]}-${fromDateParts[1]}-${fromDateParts[0]}`;

    const toDate = addDays(new Date(formattedFromDate), parseInt(daysCount) - 1);

    // format toDate as dd/mm/yyyy with date-fns
    this.toDateInputTarget.value = format(toDate, "dd/MM/yyyy");
  }

  async calculateInterestByDays(event) {
    try {
      const { contractId } = event.currentTarget.dataset;
      const fromDate = this.fromDateInputTarget.value;
      const toDate = this.toDateInputTarget.value;
      const url = `/contracts/custom_interest_payments/${contractId}?from_date=${encodeURIComponent(fromDate)}&to_date=${encodeURIComponent(toDate)}`;
      const request = new FetchRequest('get', url, {
        responseKind: 'json',
      });
      const { response } = await request.perform();
      if (response.ok) {
        const data = await response.json();
        this.setPaymentData(data);
      } else {
        alertController.show('Không thể lấy thông tin lãi theo ngày, vui lòng thử lại sau.', 'error');
      }
    } catch (error) {
      console.error(error);
      alertController.show('Đã xảy ra lỗi, vui lòng thử lại sau.', 'error');
    }
  }

  recalculateTotalInterest() {
    const interestAmount = this.#interestAmount();
    const otherAmount = this.#otherAmount();
    
    const newTotalInterestAmount = interestAmount + otherAmount;
    this.totalInterestAmountTarget.textContent = newTotalInterestAmount.toLocaleString('vi-VN') + ' VNĐ';
    this.totalInterestAmountInputTarget.value = newTotalInterestAmount.toLocaleString('vi-VN');
    this.customerPaymentAmountInputTarget.value = newTotalInterestAmount.toLocaleString('vi-VN');
  }

  setPaymentData(data) {
    this.fromDateInputTarget.value = data.from_date;
    this.toDateInputTarget.value = data.to_date;
    this.nextInterestDateTarget.textContent = data.next_interest_date;
    this.daysCountInputTarget.value = data.days_count;
    this.interestAmountTarget.textContent = data.interest_amount;
    this.interestAmountInputTarget.value = data.interest_amount.replace(' VNĐ', ''); // remove VNĐ
    this.otherAmountInputTarget.value = data.other_amount.replace(' VNĐ', ''); // remove VNĐ
    this.totalInterestAmountTarget.textContent = data.total_interest_amount;
    this.totalInterestAmountInputTarget.value = data.total_interest_amount.replace(' VNĐ', ''); // remove VNĐ
    this.customerPaymentAmountInputTarget.value = data.customer_payment_amount.replace(' VNĐ', ''); // remove VNĐ
  }

  // Private methods
  #interestAmount() {
    const interestAmount = parseFloat((this.interestAmountInputTarget.value || '0').replace(/\./g, ''));
    return isNaN(interestAmount) ? 0 : interestAmount;
  }

  #otherAmount() {
    const otherAmount = parseFloat((this.otherAmountInputTarget.value || '0').replace(/\./g, ''));
    return isNaN(otherAmount) ? 0 : otherAmount;
  }

  #fromDate() {
    const fromDate = this.fromDateInputTarget.value;
    const fromDateParts = fromDate.split('/');
    const formattedFromDate = `${fromDateParts[2]}-${fromDateParts[1]}-${fromDateParts[0]}`;
    return new Date(formattedFromDate);
  }

  #toDate() {
    const toDate = this.toDateInputTarget.value;
    const toDateParts = toDate.split('/');
    const formattedToDate = `${toDateParts[2]}-${toDateParts[1]}-${toDateParts[0]}`;
    return new Date(formattedToDate);
  }
}