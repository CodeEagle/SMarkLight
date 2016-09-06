//
//  FontEnum.swift
//  SMarkLight
//
//  Created by LawLincoln on 16/8/31.
//  Copyright © 2016年 LawLincoln. All rights reserved.
//

import Foundation

enum MFontType: String {
	case copperplateLight = "Copperplate-Light"
	case copperplate = "Copperplate"
	case copperplateBold = "Copperplate-Bold"
	case heitiSc = "Heiti SC"
	case iowanoldstyleItalic = "IowanOldStyle-Italic"
	case iowanoldstyleRoman = "IowanOldStyle-Roman"
	case iowanoldstyleBolditalic = "IowanOldStyle-BoldItalic"
	case iowanoldstyleBold = "IowanOldStyle-Bold"
	case kohinoorteluguRegular = "KohinoorTelugu-Regular"
	case kohinoorteluguMedium = "KohinoorTelugu-Medium"
	case kohinoorteluguLight = "KohinoorTelugu-Light"
	case thonburi = "Thonburi"
	case thonburiBold = "Thonburi-Bold"
	case thonburiLight = "Thonburi-Light"
	case heitiTc = "Heiti TC"
	case couriernewpsBoldmt = "CourierNewPS-BoldMT"
	case couriernewpsItalicmt = "CourierNewPS-ItalicMT"
	case couriernewpsmt = "CourierNewPSMT"
	case couriernewpsBolditalicmt = "CourierNewPS-BoldItalicMT"
	case gillsansItalic = "GillSans-Italic"
	case gillsansBold = "GillSans-Bold"
	case gillsansBolditalic = "GillSans-BoldItalic"
	case gillsansLightitalic = "GillSans-LightItalic"
	case gillsans = "GillSans"
	case gillsansLight = "GillSans-Light"
	case gillsansSemibold = "GillSans-SemiBold"
	case gillsansSemibolditalic = "GillSans-SemiBoldItalic"
	case gillsansUltrabold = "GillSans-UltraBold"
	case applesdgothicneoBold = "AppleSDGothicNeo-Bold"
	case applesdgothicneoThin = "AppleSDGothicNeo-Thin"
	case applesdgothicneoUltralight = "AppleSDGothicNeo-UltraLight"
	case applesdgothicneoRegular = "AppleSDGothicNeo-Regular"
	case applesdgothicneoLight = "AppleSDGothicNeo-Light"
	case applesdgothicneoMedium = "AppleSDGothicNeo-Medium"
	case applesdgothicneoSemibold = "AppleSDGothicNeo-SemiBold"
	case markerfeltThin = "MarkerFelt-Thin"
	case markerfeltWide = "MarkerFelt-Wide"
	case avenirnextcondensedBolditalic = "AvenirNextCondensed-BoldItalic"
	case avenirnextcondensedHeavy = "AvenirNextCondensed-Heavy"
	case avenirnextcondensedMedium = "AvenirNextCondensed-Medium"
	case avenirnextcondensedRegular = "AvenirNextCondensed-Regular"
	case avenirnextcondensedHeavyitalic = "AvenirNextCondensed-HeavyItalic"
	case avenirnextcondensedMediumitalic = "AvenirNextCondensed-MediumItalic"
	case avenirnextcondensedItalic = "AvenirNextCondensed-Italic"
	case avenirnextcondensedUltralightitalic = "AvenirNextCondensed-UltraLightItalic"
	case avenirnextcondensedUltralight = "AvenirNextCondensed-UltraLight"
	case avenirnextcondensedDemibold = "AvenirNextCondensed-DemiBold"
	case avenirnextcondensedBold = "AvenirNextCondensed-Bold"
	case avenirnextcondensedDemibolditalic = "AvenirNextCondensed-DemiBoldItalic"
	case tamilsangammn = "TamilSangamMN"
	case tamilsangammnBold = "TamilSangamMN-Bold"
	case helveticaneueItalic = "HelveticaNeue-Italic"
	case helveticaneueBold = "HelveticaNeue-Bold"
	case helveticaneueUltralight = "HelveticaNeue-UltraLight"
	case helveticaneueCondensedblack = "HelveticaNeue-CondensedBlack"
	case helveticaneueBolditalic = "HelveticaNeue-BoldItalic"
	case helveticaneueCondensedbold = "HelveticaNeue-CondensedBold"
	case helveticaneueMedium = "HelveticaNeue-Medium"
	case helveticaneueLight = "HelveticaNeue-Light"
	case helveticaneueThin = "HelveticaNeue-Thin"
	case helveticaneueThinitalic = "HelveticaNeue-ThinItalic"
	case helveticaneueLightitalic = "HelveticaNeue-LightItalic"
	case helveticaneueUltralightitalic = "HelveticaNeue-UltraLightItalic"
	case helveticaneueMediumitalic = "HelveticaNeue-MediumItalic"
	case helveticaneue = "HelveticaNeue"
	case gurmukhimnBold = "GurmukhiMN-Bold"
	case gurmukhimn = "GurmukhiMN"
	case timesnewromanpsmt = "TimesNewRomanPSMT"
	case timesnewromanpsBolditalicmt = "TimesNewRomanPS-BoldItalicMT"
	case timesnewromanpsItalicmt = "TimesNewRomanPS-ItalicMT"
	case timesnewromanpsBoldmt = "TimesNewRomanPS-BoldMT"
	case georgiaBolditalic = "Georgia-BoldItalic"
	case georgia = "Georgia"
	case georgiaItalic = "Georgia-Italic"
	case georgiaBold = "Georgia-Bold"
	case applecoloremoji = "AppleColorEmoji"
	case arialroundedmtbold = "ArialRoundedMTBold"
	case kailasaBold = "Kailasa-Bold"
	case kailasa = "Kailasa"
	case kohinoordevanagariLight = "KohinoorDevanagari-Light"
	case kohinoordevanagariRegular = "KohinoorDevanagari-Regular"
	case kohinoordevanagariSemibold = "KohinoorDevanagari-Semibold"
	case kohinoorbanglaSemibold = "KohinoorBangla-Semibold"
	case kohinoorbanglaRegular = "KohinoorBangla-Regular"
	case kohinoorbanglaLight = "KohinoorBangla-Light"
	case chalkboardseBold = "ChalkboardSE-Bold"
	case chalkboardseLight = "ChalkboardSE-Light"
	case chalkboardseRegular = "ChalkboardSE-Regular"
	case sinhalasangammnBold = "SinhalaSangamMN-Bold"
	case sinhalasangammn = "SinhalaSangamMN"
	case pingfangtcMedium = "PingFangTC-Medium"
	case pingfangtcRegular = "PingFangTC-Regular"
	case pingfangtcLight = "PingFangTC-Light"
	case pingfangtcUltralight = "PingFangTC-Ultralight"
	case pingfangtcSemibold = "PingFangTC-Semibold"
	case pingfangtcThin = "PingFangTC-Thin"
	case gujaratisangammnBold = "GujaratiSangamMN-Bold"
	case gujaratisangammn = "GujaratiSangamMN"
	case damascuslight = "DamascusLight"
	case damascusbold = "DamascusBold"
	case damascussemibold = "DamascusSemiBold"
	case damascusmedium = "DamascusMedium"
	case damascus = "Damascus"
	case noteworthyLight = "Noteworthy-Light"
	case noteworthyBold = "Noteworthy-Bold"
	case geezapro = "GeezaPro"
	case geezaproBold = "GeezaPro-Bold"
	case avenirMedium = "Avenir-Medium"
	case avenirHeavyoblique = "Avenir-HeavyOblique"
	case avenirBook = "Avenir-Book"
	case avenirLight = "Avenir-Light"
	case avenirRoman = "Avenir-Roman"
	case avenirBookoblique = "Avenir-BookOblique"
	case avenirBlack = "Avenir-Black"
	case avenirMediumoblique = "Avenir-MediumOblique"
	case avenirBlackoblique = "Avenir-BlackOblique"
	case avenirHeavy = "Avenir-Heavy"
	case avenirLightoblique = "Avenir-LightOblique"
	case avenirOblique = "Avenir-Oblique"
	case academyengravedletplain = "AcademyEngravedLetPlain"
	case diwanmishafi = "DiwanMishafi"
	case futuraCondensedmedium = "Futura-CondensedMedium"
	case futuraCondensedextrabold = "Futura-CondensedExtraBold"
	case futuraMedium = "Futura-Medium"
	case futuraMediumitalic = "Futura-MediumItalic"
	case farah = "Farah"
	case kannadasangammn = "KannadaSangamMN"
	case kannadasangammnBold = "KannadaSangamMN-Bold"
	case arialhebrewBold = "ArialHebrew-Bold"
	case arialhebrewLight = "ArialHebrew-Light"
	case arialhebrew = "ArialHebrew"
	case arialmt = "ArialMT"
	case arialBolditalicmt = "Arial-BoldItalicMT"
	case arialBoldmt = "Arial-BoldMT"
	case arialItalicmt = "Arial-ItalicMT"
	case partyletplain = "PartyLetPlain"
	case chalkduster = "Chalkduster"
	case hoeflertextItalic = "HoeflerText-Italic"
	case hoeflertextRegular = "HoeflerText-Regular"
	case hoeflertextBlack = "HoeflerText-Black"
	case hoeflertextBlackitalic = "HoeflerText-BlackItalic"
	case optimaRegular = "Optima-Regular"
	case optimaExtrablack = "Optima-ExtraBlack"
	case optimaBolditalic = "Optima-BoldItalic"
	case optimaItalic = "Optima-Italic"
	case optimaBold = "Optima-Bold"
	case palatinoBold = "Palatino-Bold"
	case palatinoRoman = "Palatino-Roman"
	case palatinoBolditalic = "Palatino-BoldItalic"
	case palatinoItalic = "Palatino-Italic"
	case laosangammn = "LaoSangamMN"
	case malayalamsangammnBold = "MalayalamSangamMN-Bold"
	case malayalamsangammn = "MalayalamSangamMN"
	case alnileBold = "AlNile-Bold"
	case alnile = "AlNile"
	case bradleyhanditcttBold = "BradleyHandITCTT-Bold"
	case pingfanghkUltralight = "PingFangHK-Ultralight"
	case pingfanghkSemibold = "PingFangHK-Semibold"
	case pingfanghkThin = "PingFangHK-Thin"
	case pingfanghkLight = "PingFangHK-Light"
	case pingfanghkRegular = "PingFangHK-Regular"
	case pingfanghkMedium = "PingFangHK-Medium"
	case trebuchetBolditalic = "Trebuchet-BoldItalic"
	case trebuchetms = "TrebuchetMS"
	case trebuchetmsBold = "TrebuchetMS-Bold"
	case trebuchetmsItalic = "TrebuchetMS-Italic"
	case helveticaBold = "Helvetica-Bold"
	case helvetica = "Helvetica"
	case helveticaLightoblique = "Helvetica-LightOblique"
	case helveticaOblique = "Helvetica-Oblique"
	case helveticaBoldoblique = "Helvetica-BoldOblique"
	case helveticaLight = "Helvetica-Light"
	case courierBoldoblique = "Courier-BoldOblique"
	case courier = "Courier"
	case courierBold = "Courier-Bold"
	case courierOblique = "Courier-Oblique"
	case cochinBold = "Cochin-Bold"
	case cochin = "Cochin"
	case cochinItalic = "Cochin-Italic"
	case cochinBolditalic = "Cochin-BoldItalic"
	case hiraminpronW6 = "HiraMinProN-W6"
	case hiraminpronW3 = "HiraMinProN-W3"
	case devanagarisangammn = "DevanagariSangamMN"
	case devanagarisangammnBold = "DevanagariSangamMN-Bold"
	case oriyasangammn = "OriyaSangamMN"
	case oriyasangammnBold = "OriyaSangamMN-Bold"
	case snellroundhandBold = "SnellRoundhand-Bold"
	case snellroundhand = "SnellRoundhand"
	case snellroundhandBlack = "SnellRoundhand-Black"
	case zapfdingbatsitc = "ZapfDingbatsITC"
	case bodonisvtytwoitcttBold = "BodoniSvtyTwoITCTT-Bold"
	case bodonisvtytwoitcttBook = "BodoniSvtyTwoITCTT-Book"
	case bodonisvtytwoitcttBookita = "BodoniSvtyTwoITCTT-BookIta"
	case verdanaItalic = "Verdana-Italic"
	case verdanaBolditalic = "Verdana-BoldItalic"
	case verdana = "Verdana"
	case verdanaBold = "Verdana-Bold"
	case americantypewriterCondensedlight = "AmericanTypewriter-CondensedLight"
	case americantypewriter = "AmericanTypewriter"
	case americantypewriterCondensedbold = "AmericanTypewriter-CondensedBold"
	case americantypewriterLight = "AmericanTypewriter-Light"
	case americantypewriterBold = "AmericanTypewriter-Bold"
	case americantypewriterCondensed = "AmericanTypewriter-Condensed"
	case avenirnextUltralight = "AvenirNext-UltraLight"
	case avenirnextUltralightitalic = "AvenirNext-UltraLightItalic"
	case avenirnextBold = "AvenirNext-Bold"
	case avenirnextBolditalic = "AvenirNext-BoldItalic"
	case avenirnextDemibold = "AvenirNext-DemiBold"
	case avenirnextDemibolditalic = "AvenirNext-DemiBoldItalic"
	case avenirnextMedium = "AvenirNext-Medium"
	case avenirnextHeavyitalic = "AvenirNext-HeavyItalic"
	case avenirnextHeavy = "AvenirNext-Heavy"
	case avenirnextItalic = "AvenirNext-Italic"
	case avenirnextRegular = "AvenirNext-Regular"
	case avenirnextMediumitalic = "AvenirNext-MediumItalic"
	case baskervilleItalic = "Baskerville-Italic"
	case baskervilleSemibold = "Baskerville-SemiBold"
	case baskervilleBolditalic = "Baskerville-BoldItalic"
	case baskervilleSemibolditalic = "Baskerville-SemiBoldItalic"
	case baskervilleBold = "Baskerville-Bold"
	case baskerville = "Baskerville"
	case khmersangammn = "KhmerSangamMN"
	case didotItalic = "Didot-Italic"
	case didotBold = "Didot-Bold"
	case didot = "Didot"
	case savoyeletplain = "SavoyeLetPlain"
	case bodoniornamentsitctt = "BodoniOrnamentsITCTT"
	case symbol = "Symbol"
	case menloItalic = "Menlo-Italic"
	case menloBold = "Menlo-Bold"
	case menloRegular = "Menlo-Regular"
	case menloBolditalic = "Menlo-BoldItalic"
	case bodonisvtytwoscitcttBook = "BodoniSvtyTwoSCITCTT-Book"
	case papyrus = "Papyrus"
	case papyrusCondensed = "Papyrus-Condensed"
	case hiraginosansW3 = "HiraginoSans-W3"
	case hiraginosansW6 = "HiraginoSans-W6"
	case pingfangscUltralight = "PingFangSC-Ultralight"
	case pingfangscRegular = "PingFangSC-Regular"
	case pingfangscSemibold = "PingFangSC-Semibold"
	case pingfangscThin = "PingFangSC-Thin"
	case pingfangscLight = "PingFangSC-Light"
	case pingfangscMedium = "PingFangSC-Medium"
	case euphemiaucasItalic = "EuphemiaUCAS-Italic"
	case euphemiaucas = "EuphemiaUCAS"
	case euphemiaucasBold = "EuphemiaUCAS-Bold"
	case teluguSangamMn = "Telugu Sangam MN"
	case banglaSangamMn = "Bangla Sangam MN"
	case zapfino = "Zapfino"
	case bodonisvtytwoositcttBook = "BodoniSvtyTwoOSITCTT-Book"
	case bodonisvtytwoositcttBold = "BodoniSvtyTwoOSITCTT-Bold"
	case bodonisvtytwoositcttBookit = "BodoniSvtyTwoOSITCTT-BookIt"

}