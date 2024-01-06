//
//  SharedTestHelpers.swift
//  FeedTests
//
//  Created by hamedpouramiri on 8/12/23.
//

import Foundation
import TradeKyc

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
}

func anyMarzbanError() -> MarzbanServiceError {
    .invalidData
}

func anyURL() -> URL {
    URL(string: "http://any-url.com")!
}
