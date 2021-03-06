//
//  DateTimeFormat.swift
//  gsnet
//
//  Created by Gabor Soulavy on 20/11/2015.
//  Copyright © 2015 Gabor Soulavy. All rights reserved.
//

public enum DateTimeFormat: String {
    case FULL = "yyyy-MM-dd HH:mm:ss.SSS",
         LONG = "yyyy-MM-dd HH:mm:ss",
         Filename = "yyyy.MM.dd-HH.mm.ss",
         ShortDate = "dd/MM/yy",
         ShortTime = "h:mm a",
         ShortTimeM = "HH:mm",
         MediumDate = "dd. MMM, yyyy.",
         MediumDateA = "MMM dd, yyyy.",
         MediumTime = "h:mm:ss a",
         MediumTimeM = "HH:mm:ss",
         LongDate = "dd. MMMM, yyyy.",
         ISO = "yyyy-MM-ddTHH:mm:ssZ"
}
