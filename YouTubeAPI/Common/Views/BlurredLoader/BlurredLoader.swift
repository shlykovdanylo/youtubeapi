import UIKit

class BlurredLoader: UIView {
	private var contentView: UIView!
	@IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		xibSetup()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		xibSetup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		xibSetup()
	}
	
	private func xibSetup() {
		guard let view = loadViewFromNib() else { return }
		view.frame = bounds
		view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		addSubview(view)
		contentView = view
        contentView.layer.cornerRadius = 16
	}
	
	private func loadViewFromNib() -> UIView? {
		let bundle = Bundle(for: type(of: self))
		let nib = UINib(nibName: "BlurredLoader", bundle: bundle)
		return nib.instantiate(withOwner: self, options: nil).first as? UIView
	}
	
	func startAnimating() {
		isHidden = false
        
        activityIndicator.startAnimating()
        
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 1
        }, completion:  nil)
	}
	
	func stopAnimating() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }, completion: { (value: Bool) in
            self.activityIndicator.stopAnimating()
            self.isHidden = true
        })
	}
	
    var shouldStartActivityIndicator: Bool = false
    
    func startAnimatingWith(delay: Double) {
        shouldStartActivityIndicator = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            if self.shouldStartActivityIndicator {
                self.startAnimating()
            }
        }
    }
    
    func stopAnimatingWithDelay() {
        shouldStartActivityIndicator = false
        self.stopAnimating()
    }
    
	func centerInto(view: UIView) {
		translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			centerXAnchor.constraint(equalTo: view.centerXAnchor),
			centerYAnchor.constraint(equalTo: view.centerYAnchor),
			heightAnchor.constraint(equalToConstant: 100),
			widthAnchor.constraint(equalToConstant: 100)
        ])
	}
}
