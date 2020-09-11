//
//  TaskType.swift
//  eCabinet
//
//  Created by HP-DIT on 9/8/20.
//  Copyright © 2020 HP-DIT. All rights reserved.
//

import Foundation

enum TaskType : String {
    
    case GET_ROLES
    case GET_DEPARTMENTS_VIA_ROLES
    case GET_BRANCHES
    case GET_USERS
    case GET_OTP_VIA_MOBILE
    case LOGIN
    case GET_MENU_LIST
    case CABINET_MEETING_STATUS
    case GET_PENDING_MEMO_LIST_CABINET
    case CABINET_MEMOS_DETAILS
    case SEND_BACK
    case FORWARD
    case ALLOW
    case GET_ALLOWED_MEMO_LIST_CABINET
    case GET_PUBLISHED_MEETING_ID_BY_ROLE
    case FINAL_MEETING_AGENDA_LIST

   
}
