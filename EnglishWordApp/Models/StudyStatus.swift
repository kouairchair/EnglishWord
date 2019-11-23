//
//  StudyStatus.swift
//  EnglishWordApp
//
//  Created by headspinnerd on 2019/11/03.
//  Copyright © 2019 headspinnerd. All rights reserved.
//

import Foundation

public enum StudyStatus: Int, CaseIterable, Codable, Hashable {
    case Forgot = -1 // 1回目正解、2回目不正解または1回目不正解（1時間後に再出題対象）
    case HitOnce = 0 // 1回のみ出題で正解（7日後に再出題対象）
    case HitOnceAfterFailed = 1 // 不正解の後に1回正解（1日後に再出題対象）
    case HitTwiceAfterFailed = 2 // 不正解の後に2回連続正解（3日後に再出題対象）
    case HitThreeAfterFailed = 3 // 不正解の後に3回連続正解（7日後に再出題対象）
    case HitFourAfterFailed = 4 // 不正解の後に4回連続正解（30日後に再出題対象）
    case Master = 5 // 2回連続正解または不正解の後に5回連続正解（3回目の出題はなし）
    case NeverSeen = 6 // 未出題（必ず出題対象）
}
