import UIKit
import BigInt // For big integers
class ViewController: UIViewController {
    var workItem: DispatchWorkItem?
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter
    }()

    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var answerTextView: UITextView!
    @IBAction func calculate(_ sender: UIButton) {
        var result:BigInt = BigInt(1)
        answerTextView.text = ""
        calculateButton.isEnabled = false
        let newWorkItem = DispatchWorkItem {
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
        self.workItem?.cancel()
        self.workItem = nil
        print("Entered UI Update \(self.dateFormatter.string(from: Date()))")
        // ISSUE: THE NEXT TWO LINES ARE EXECUTED 4 SECONDS AFTER ABOVE LINE!!
        self.answerTextView.text = "\(result)"
        self.calculateButton.isEnabled = true
        print("UI Updated \(self.dateFormatter.string(from: Date()))")
        
    }
}   
