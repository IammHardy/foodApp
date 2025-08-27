import { Controller } from "@hotwired/stimulus"
import Chart from "chart.js/auto"

export default class extends Controller {
  connect() {
    const dailyData = JSON.parse(this.element.dataset.dailySales || "{}")
    const monthlyData = JSON.parse(this.element.dataset.monthlySales || "{}")

    // Convert Rails hash into arrays
    const dailyLabels = Object.keys(dailyData)
    const dailyValues = Object.values(dailyData)

    const monthlyLabels = Object.keys(monthlyData)
    const monthlyValues = Object.values(monthlyData)

    // Debug log
    console.log("Daily Sales:", dailyData)
    console.log("Monthly Sales:", monthlyData)

    // Only render chart if data exists
    if (dailyLabels.length > 0) {
      new Chart(document.getElementById("daily-sales-chart"), {
        type: "bar",
        data: {
          labels: dailyLabels,
          datasets: [{
            label: "Daily Sales (₦)",
            data: dailyValues,
            backgroundColor: "rgba(75, 192, 192, 0.5)"
          }]
        }
      })
    }

    if (monthlyLabels.length > 0) {
      new Chart(document.getElementById("monthly-sales-chart"), {
        type: "line",
        data: {
          labels: monthlyLabels,
          datasets: [{
            label: "Monthly Sales (₦)",
            data: monthlyValues,
            borderColor: "rgba(255, 99, 132, 1)",
            fill: false
          }]
        }
      })
    }
  }
}
