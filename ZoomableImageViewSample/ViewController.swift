//
//  ViewController.swift
//  ZoomableImageViewSample
//
//  Created by Hiroki Ishiura on 2015/09/20.
//  Copyright © 2015年 Hiroki Ishiura. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

	// Main.storyboard:
	//
	//   self.view (UIView)
	//       -> self.scrollView (UIScrollView)
	//           -> self.imageView (UIImageView)
	//
	//   See the Attributes, Size and Connections Inspector of scrollView.
	//   See the Size and Connections Inspector of imageView.
	//     Intrinsic Size of imageView is Placefolder.
	//
	
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var imageView: UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()

		let image = UIImage(named: "SampleImage.jpg")
		self.imageView.image = image
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		adjustScrollViewZoomScale(false)
		adjustScrollViewContentInset(false)
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		self.scrollView.zoomScale = self.scrollView.minimumZoomScale
	}
	
	func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
		return self.imageView;
	}
	
	func scrollViewDidZoom(scrollView: UIScrollView) {
		adjustScrollViewContentInset(false)
	}
	
	@IBAction func didTapScrollView(sender: UITapGestureRecognizer) {
		
		let minimumZoomScale = self.scrollView.minimumZoomScale
		let maximumZoomScale = self.scrollView.maximumZoomScale
		let boundaryScale = (maximumZoomScale - minimumZoomScale) / 2.0 + minimumZoomScale
		
		if boundaryScale > self.scrollView.zoomScale {
			// Zoom in to the point tapped.
			var point = sender.locationInView(self.scrollView)
			point.x /= self.scrollView.zoomScale
			point.y /= self.scrollView.zoomScale
			var rect = CGRect()
			rect.size.width  = self.scrollView.bounds.size.width / maximumZoomScale
			rect.size.height = self.scrollView.bounds.size.height / maximumZoomScale
			rect.origin.x = point.x - (rect.size.width  / 2.0)
			rect.origin.y = point.y - (rect.size.height / 2.0)
			self.scrollView.zoomToRect(rect, animated: true)
			
		} else {
			// Zoom out.
			self.scrollView.setZoomScale(minimumZoomScale, animated: true)
			
		}
	}
	
	private func adjustScrollViewZoomScale(animated: Bool) {
		
		let width = self.scrollView.frame.size.width
		var height = self.scrollView.frame.size.height
		height -= self.topLayoutGuide.length
		height -= self.bottomLayoutGuide.length
		
		let minimumZoomScaleX : CGFloat
		let minimumZoomScaleY : CGFloat
		if self.imageView.image != nil {
			minimumZoomScaleX = width / self.imageView.intrinsicContentSize().width
			minimumZoomScaleY = height / self.imageView.intrinsicContentSize().height
		} else {
			minimumZoomScaleX = width / self.scrollView.bounds.width
			minimumZoomScaleY = height / self.scrollView.bounds.height
		}
		let minimumZoomScale = min(minimumZoomScaleX, minimumZoomScaleY)
		
		self.scrollView.minimumZoomScale = minimumZoomScale
		self.scrollView.maximumZoomScale = 1.0
		
		var zoomScale = self.scrollView.zoomScale
		zoomScale = min(max(zoomScale, minimumZoomScale), 1.0)
		
		self.scrollView.setZoomScale(zoomScale, animated: animated)
	}
	
	private func adjustScrollViewContentInset(animated: Bool) {
		
		let inset : UIEdgeInsets
		if self.imageView.image != nil {
			let width = self.scrollView.frame.size.width
			var height = self.scrollView.frame.size.height
			height -= self.topLayoutGuide.length
			height -= self.bottomLayoutGuide.length
			
			var insetHorizontal = (width - self.scrollView.contentSize.width) / 2.0
			var insetVertical = (height - self.scrollView.contentSize.height) / 2.0
			insetHorizontal = max(0.0, insetHorizontal)
			insetVertical = max(0.0, insetVertical)
			let insetTop = insetVertical + self.topLayoutGuide.length
			let insetBottom = insetVertical + self.bottomLayoutGuide.length
			inset = UIEdgeInsets(top: insetTop, left: insetHorizontal, bottom: insetBottom, right: insetHorizontal)
			
		} else {
			inset = UIEdgeInsetsZero
		}

		if animated {
			UIView.animateWithDuration(0.25, animations: { () -> Void in
				self.scrollView.contentInset = inset
			})
		} else {
			self.scrollView.contentInset = inset
		}
	}
}

