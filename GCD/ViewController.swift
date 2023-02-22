import UIKit
import BigInt // For big integers
class ViewController: UIViewController {
    var workItem: DispatchWorkItem?
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS "
        return formatter
    }()

    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var answerTextView: UITextView!
    @IBAction func calculate(_ sender: UIButton) {
        var result:BigInt = BigInt(1)
        answerTextView.text = ""
        calculateButton.isEnabled = false
        let newWorkItem = DispatchWorkItem {
            self.workItem?.cancel()
            result = self.LongRunningFunction()
        }
        let notifyView = DispatchWorkItem {
            self.UpdateUI( result: result)
        }
        newWorkItem.notify(queue: .main) {
            notifyView.perform()
        }
        self.workItem = newWorkItem
        DispatchQueue.global().async(execute: newWorkItem)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answerTextView.text = ""
    }
    func LongRunningFunction() -> BigInt {
        return (1 ... BigInt(7777)).map { BigInt($0) }.reduce(BigInt(1), *)
    }
    func UpdateUI(result: BigInt) {
        print(dateFormatter.string(from: Date()))
        self.calculateButton.isEnabled = true
        self.answerTextView.text = "\(result)"
        print(dateFormatter.string(from: Date()))
    }
}   
