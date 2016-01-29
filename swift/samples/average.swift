//
//  main.swift
//  averageme
//
//  Created by Dave Grove on 1/22/16.
//  Copyright © 2016 Dave Grove. All rights reserved.
//

import Dispatch

func average_async(nums: [Int], _ dg:dispatch_group_t,
                   _ queue: dispatch_queue_t, _ callback:(Int)->Void) {
    dispatch_group_async(dg, queue) {
        let avg = nums.reduce(0, combine: +) / nums.count
        dispatch_group_async(dg, queue) { callback(avg) }
    }
}


print("HELLO")


let dg = dispatch_group_create();
dispatch_group_enter(dg);
//let q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
let q = dispatch_get_global_queue(0, 0);
let cb:(Int)->Void = { a in print("The average is \(a)\n") }
let nums = [1,2,3,4,5]
average_async(nums, dg, q, cb)
average_async([10,20,30,40,50,60], dg, q, cb)
dispatch_group_leave(dg)
dispatch_group_wait(dg, DISPATCH_TIME_FOREVER);


print("GOODBYE")

