//
//  BXRefreshControl.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-11-27.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import UIKit

class BXRefreshControll: UIRefreshControl {
    
    var refreshLoadingView : UIView?
    var refreshColorView : UIView?
    var compass_background : UIImageView?
    var compass_spinner : UIImageView?
    
    var isRefreshIconsOverlap = false
    var isRefreshAnimating = false
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupUI()
    }
    
    private func setupUI() {
        
        // Setup the loading view, which will hold the moving graphics
        self.refreshLoadingView = self.refreshLoadingView ?? UIView(frame: self.bounds)
        self.refreshLoadingView?.backgroundColor = UIColor.clear
        
        // Setup the color view, which will display the rainbowed background
        self.refreshColorView = self.refreshColorView ?? UIView(frame: self.bounds)
        self.refreshColorView?.backgroundColor = UIColor.clear
        self.refreshColorView?.alpha = 0.30
        
        // Create the graphic image views
        compass_background = compass_background ?? UIImageView(image: UIImage(named: "compass_background.png"))
        compass_spinner = compass_spinner ?? UIImageView(image: UIImage(named: "compass_spinner.png"))
        
        // Add the graphics to the loading view
        if !compass_background!.hasParentView {
            self.refreshLoadingView?.addSubview(self.compass_background!)
        }
        
        if !compass_spinner!.hasParentView {
            self.refreshLoadingView?.addSubview(self.compass_spinner!)
        }
        
        // Clip so the graphics don't stick out
        self.refreshLoadingView?.clipsToBounds = true;
        
        // Hide the original spinner icon
        tintColor = UIColor.clear
        
        // Add the loading and colors views to our refresh control
        
        if !refreshColorView!.hasParentView {
            addSubview(refreshColorView!)
        }
        if !refreshLoadingView!.hasParentView {
            addSubview(refreshLoadingView!)
        }
        
        // Initalize flags
        self.isRefreshIconsOverlap = false;
        self.isRefreshAnimating = false;
    }
    
    func updateAnimation(midX: CGFloat) {
        
        //print("Update Animation")
        // Get the current size of the refresh controller
        var refreshBounds = self.bounds
        
        // Distance the table has been pulled >= 0
        let pullDistance = max(0.0, -frame.origin.y);
        
        // Half the width of the table
        
        // Calculate the width and height of our graphics
        let compassHeight = self.compass_background!.bounds.size.height;
        let compassHeightHalf = compassHeight / 2.0;
        
        let compassWidth = self.compass_background!.bounds.size.width;
        let compassWidthHalf = compassWidth / 2.0;
        
        let spinnerHeight = self.compass_spinner!.bounds.size.height;
        let spinnerHeightHalf = spinnerHeight / 2.0;
        
        let spinnerWidth = self.compass_spinner!.bounds.size.width;
        let spinnerWidthHalf = spinnerWidth / 2.0;
        
        // Calculate the pull ratio, between 0.0-1.0
        let pullRatio = min( max(pullDistance, 0.0), 100.0) / 100.0;
        
        // Set the Y coord of the graphics, based on pull distance
        let compassY = pullDistance / 2.0 - compassHeightHalf;
        let spinnerY = pullDistance / 2.0 - spinnerHeightHalf;
        
        // Calculate the X coord of the graphics, adjust based on pull ratio
        var compassX = (midX + compassWidthHalf) - (compassWidth * pullRatio);
        var spinnerX = (midX - spinnerWidth - spinnerWidthHalf) + (spinnerWidth * pullRatio);
        
        // When the compass and spinner overlap, keep them together
        if (fabsf(Float(compassX - spinnerX)) < 1.0) {
            self.isRefreshIconsOverlap = true;
        }
        
        // If the graphics have overlapped or we are refreshing, keep them together
        if (self.isRefreshIconsOverlap || self.isRefreshing) {
            compassX = midX - compassWidthHalf;
            spinnerX = midX - spinnerWidthHalf;
        }
        
        // Set the graphic's frames
        var compassFrame = self.compass_background!.frame;
        compassFrame.origin.x = compassX;
        compassFrame.origin.y = compassY;
        
        var spinnerFrame = self.compass_spinner!.frame;
        spinnerFrame.origin.x = spinnerX;
        spinnerFrame.origin.y = spinnerY;
        
        self.compass_background!.frame = compassFrame;
        self.compass_spinner!.frame = spinnerFrame;
        
        // Set the encompassing view's frames
        refreshBounds.size.height = pullDistance;
        
        self.refreshColorView!.frame = refreshBounds;
        self.refreshLoadingView!.frame = refreshBounds;
        
        // If we're refreshing and the animation is not playing, then play the animation
        if (self.isRefreshing && !self.isRefreshAnimating) {
            animateRefreshView()
        }
        
    }
    
    private func animateRefreshView() {
        
        // Background color to loop through for our color view
        print("animateRefreshView")
        var colorArray = [StyleSheet.defaultTheme.mainColor]
        
        // In Swift, static variables must be members of a struct or class
        struct ColorIndex {
            static var colorIndex = 0
            static var aniInedx = 1
        }
        
        // Flag that we are animating
        self.isRefreshAnimating = true;
        
        UIView.animate(
            withDuration: Double(6.0),
            delay: Double(0.0),
            options: UIViewAnimationOptions.curveLinear,
            animations: {
                // Rotate the spinner by M_PI_2 = PI/2 = 90 degrees
                self.compass_spinner?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2.0) * CGFloat(ColorIndex.aniInedx))
                ColorIndex.aniInedx += 1
                
        },
        completion: { finished in
            // If still refreshing, keep spinning, else reset
            if (self.isRefreshing) {
                self.animateRefreshView()
            }else {
                self.resetAnimation()
            }
        })
    }
    
    private func resetAnimation() {
        
        // Reset our flags and }background color
        self.isRefreshAnimating = false;
        self.isRefreshIconsOverlap = false;
        self.refreshColorView?.backgroundColor = UIColor.clear
        self.compass_spinner?.transform = .identity
    }
    
}


