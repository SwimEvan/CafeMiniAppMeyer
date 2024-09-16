import UIKit

class ViewController: UIViewController {
    // Initial food items and prices
    var foodItems = ["Apple", "Banana", "Carrot", "Donut", "Eggplant"]
    var foodPrices = [1.0, 0.5, 0.75, 1.5, 2.0]
   
    // Cart dictionary
    var cart = [String: Int]()
   
    // Outlets for UI components
   
   
    @IBOutlet weak var foodTextView: UITextView!
  
    @IBOutlet weak var itemTF: UITextField!
    
    @IBOutlet weak var cartTV: UITextView!
    
   
    @IBOutlet weak var quantityTF: UITextField!
    
    @IBOutlet weak var adminPasswordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayFoodItems()
    }
   
    // Display all food items and their prices
    func displayFoodItems() {
        var displayText = ""
        for (index, item) in foodItems.enumerated() {
            displayText += "\(item): $\(foodPrices[index])\n"
        }
        foodTextView.text = displayText
    }
   
    // Add item to cart
   
    @IBAction func addToCard(_ sender: UIButton) {
    guard let item = itemTF.text, let quantityText = quantityTF.text, let quantity = Int(quantityText), quantity > 0 else {
            showError(message: "Invalid input. Please enter a valid item and quantity.")
            return
        }
       
        if let index = foodItems.firstIndex(of: item) {
            if cart[item] != nil {
                showError(message: "Item already in cart. Please update the quantity.")
                return
            }
            cart[item] = quantity
            updateCart()
        } else {
            showError(message: "Item not found in menu.")
        }
    }
   
    // Update cart and display total price
    func updateCart() {
        var displayText = ""
        var totalPrice = 0.0
        for (item, quantity) in cart {
            if let index = foodItems.firstIndex(of: item) {
                let price = foodPrices[index]
                totalPrice += price * Double(quantity)
                displayText += "\(item): \(quantity) x $\(price) = $\(price * Double(quantity))\n"
            }
        }
        displayText += "Total Price: $\(totalPrice)"
        cartTV.text = displayText
    }
   
    // Show error messages
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
   
    // Admin actions
    @IBAction func adminActions(_ sender: UIButton) {
        let adminPassword = "admin123"
        if adminPasswordTF.text == adminPassword {
            let alert = UIAlertController(title: "Admin Actions", message: nil, preferredStyle: .alert)
            alert.addTextField { textField in
                textField.placeholder = "Item Name"
            }
            alert.addTextField { textField in
                textField.placeholder = "Item Price"
                textField.keyboardType = .decimalPad
            }
            alert.addAction(UIAlertAction(title: "Add Item", style: .default, handler: { [weak self] _ in
                if let itemName = alert.textFields?[0].text, let itemPriceText = alert.textFields?[1].text, let itemPrice = Double(itemPriceText) {
                    self?.addMenuItem(name: itemName, price: itemPrice)
                }
            }))
           
            alert.addAction(UIAlertAction(title: "Delete Item", style: .destructive, handler: { [weak self] _ in
                if let itemName = alert.textFields?[0].text {
                    self?.deleteMenuItem(name: itemName)
                }
            }))
           
            present(alert, animated: true, completion: nil)
        } else {
            showError(message: "Invalid password.")
        }
    }
   
    // Add menu item
    func addMenuItem(name: String, price: Double) {
        foodItems.append(name)
        foodPrices.append(price)
        displayFoodItems()
    }
   
    // Delete menu item
    func deleteMenuItem(name: String) {
        if let index = foodItems.firstIndex(of: name) {
            foodItems.remove(at: index)
            foodPrices.remove(at: index)
            cart.removeValue(forKey: name) // Remove from cart if exists
            updateCart()
            displayFoodItems()
        } else {
            showError(message: "Item not found.")
        }
    }
}

