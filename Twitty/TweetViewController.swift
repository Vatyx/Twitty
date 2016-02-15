import UIKit

class TweetViewController: UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var characterCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.becomeFirstResponder()
        self.automaticallyAdjustsScrollViewInsets = false
        textView.delegate = self
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let newLength:Int = (textView.text as NSString).length + (text as NSString).length - range.length
        let remainingChar:Int = 140 - newLength
        characterCountLabel.text = "\(remainingChar) characters left"
        
        return (newLength < 140)
    }
    
    @IBAction func sendTweet(sender: AnyObject) {
        TwitterClient.sharedInstance.sendTweet(textView.text, params: nil) { (response, error) -> () in
            if (error == nil){
                self.dismissViewControllerAnimated(true, completion: {});
            }else{
                print("posting tweet failed")
            }
        }
    }
    @IBAction func sendButtonClicked(sender: UIBarButtonItem) {
        
    }
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}