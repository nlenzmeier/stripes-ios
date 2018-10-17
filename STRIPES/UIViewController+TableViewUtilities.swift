//
//  UIViewController+TableViewUtilities.swift
//  STRIPES
//
//  Copyright © 2018 Nicolle Lenzmeier. All rights reserved.
//

import UIKit

extension UIViewController {

    /// This function will deselect any selected table view rows correctly. It is designed primarily to be called in viewWillAppear so that it will work in conjunction with any animation transition coordinator (like the pan gesture in a UINavigationController) to correctly animate all selected table cells.
    ///
    /// - Parameter tableView: The table view that has the cells you want to deselect.
    func deselectRows(in tableView: UITableView) {
        // Get the initially selected index paths, if any
        let selectedIndexPaths = tableView.indexPathsForSelectedRows ?? []

        // Grab the transition coordinator responsible for the current transition
        if let coordinator = transitionCoordinator {
            coordinator.animate(
                alongsideTransition: { context in
                    // Deselect the cells, with animations enabled if this is an animated transition
                    selectedIndexPaths.forEach {
                        tableView.deselectRow(at: $0, animated: context.isAnimated)
                    }
            },
                completion: { context in
                    // If the transition was cancel reselect the rows that were selected before so they are still selected the next time the same animation is triggered
                    if context.isCancelled {
                        selectedIndexPaths.forEach {
                            tableView.selectRow(at: $0, animated: false, scrollPosition: .none)
                        }
                    }
            })
        } else {
            // If this isn't a transition coordinator, just deselect the rows without animating
            selectedIndexPaths.forEach {
                tableView.deselectRow(at: $0, animated: false)
            }
        }
    }
}
