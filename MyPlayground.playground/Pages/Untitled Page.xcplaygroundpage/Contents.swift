// : Playground - noun: a place where people can play

import UIKit
//let a = UIFont(name: "Menlo-Bold", size: 16)
print("enum MFontType: String {")
for fontFamily in UIFont.familyNames() {

//	print("Font family name = \(fontFamily as String)")
	var hasSub = false
	for fontName in UIFont.fontNamesForFamilyName(fontFamily as String) {
		var names = fontName.componentsSeparatedByString("-")
		let pre = names.removeFirst().lowercaseString
		let last = names.popLast()?.capitalizedString
		let name = pre + (last ?? "")
		print("case \(name) = \"\(fontName)\"")
		hasSub = true
	}
	if !hasSub {
		var names = fontFamily.componentsSeparatedByString(" ")
		let pre = names.removeFirst().lowercaseString
		let left = names.flatMap({ $0.capitalizedString }).joinWithSeparator("")
		let name = pre + left
		print("case \(name) = \"\(fontFamily)\"")
	}

//	print("\n");

}
print("}\n")
/*
 Font family name = Copperplate
 - Font name = Copperplate-Light
 - Font name = Copperplate
 - Font name = Copperplate-Bold


 Font family name = Heiti SC


 Font family name = Iowan Old Style
 - Font name = IowanOldStyle-Italic
 - Font name = IowanOldStyle-Roman
 - Font name = IowanOldStyle-BoldItalic
 - Font name = IowanOldStyle-Bold


 Font family name = Kohinoor Telugu
 - Font name = KohinoorTelugu-Regular
 - Font name = KohinoorTelugu-Medium
 - Font name = KohinoorTelugu-Light


 Font family name = Thonburi
 - Font name = Thonburi
 - Font name = Thonburi-Bold
 - Font name = Thonburi-Light


 Font family name = Heiti TC


 Font family name = Courier New
 - Font name = CourierNewPS-BoldMT
 - Font name = CourierNewPS-ItalicMT
 - Font name = CourierNewPSMT
 - Font name = CourierNewPS-BoldItalicMT


 Font family name = Gill Sans
 - Font name = GillSans-Italic
 - Font name = GillSans-Bold
 - Font name = GillSans-BoldItalic
 - Font name = GillSans-LightItalic
 - Font name = GillSans
 - Font name = GillSans-Light
 - Font name = GillSans-SemiBold
 - Font name = GillSans-SemiBoldItalic
 - Font name = GillSans-UltraBold


 Font family name = Apple SD Gothic Neo
 - Font name = AppleSDGothicNeo-Bold
 - Font name = AppleSDGothicNeo-Thin
 - Font name = AppleSDGothicNeo-UltraLight
 - Font name = AppleSDGothicNeo-Regular
 - Font name = AppleSDGothicNeo-Light
 - Font name = AppleSDGothicNeo-Medium
 - Font name = AppleSDGothicNeo-SemiBold


 Font family name = Marker Felt
 - Font name = MarkerFelt-Thin
 - Font name = MarkerFelt-Wide


 Font family name = Avenir Next Condensed
 - Font name = AvenirNextCondensed-BoldItalic
 - Font name = AvenirNextCondensed-Heavy
 - Font name = AvenirNextCondensed-Medium
 - Font name = AvenirNextCondensed-Regular
 - Font name = AvenirNextCondensed-HeavyItalic
 - Font name = AvenirNextCondensed-MediumItalic
 - Font name = AvenirNextCondensed-Italic
 - Font name = AvenirNextCondensed-UltraLightItalic
 - Font name = AvenirNextCondensed-UltraLight
 - Font name = AvenirNextCondensed-DemiBold
 - Font name = AvenirNextCondensed-Bold
 - Font name = AvenirNextCondensed-DemiBoldItalic


 Font family name = Tamil Sangam MN
 - Font name = TamilSangamMN
 - Font name = TamilSangamMN-Bold


 Font family name = Helvetica Neue
 - Font name = HelveticaNeue-Italic
 - Font name = HelveticaNeue-Bold
 - Font name = HelveticaNeue-UltraLight
 - Font name = HelveticaNeue-CondensedBlack
 - Font name = HelveticaNeue-BoldItalic
 - Font name = HelveticaNeue-CondensedBold
 - Font name = HelveticaNeue-Medium
 - Font name = HelveticaNeue-Light
 - Font name = HelveticaNeue-Thin
 - Font name = HelveticaNeue-ThinItalic
 - Font name = HelveticaNeue-LightItalic
 - Font name = HelveticaNeue-UltraLightItalic
 - Font name = HelveticaNeue-MediumItalic
 - Font name = HelveticaNeue


 Font family name = Gurmukhi MN
 - Font name = GurmukhiMN-Bold
 - Font name = GurmukhiMN


 Font family name = Times New Roman
 - Font name = TimesNewRomanPSMT
 - Font name = TimesNewRomanPS-BoldItalicMT
 - Font name = TimesNewRomanPS-ItalicMT
 - Font name = TimesNewRomanPS-BoldMT


 Font family name = Georgia
 - Font name = Georgia-BoldItalic
 - Font name = Georgia
 - Font name = Georgia-Italic
 - Font name = Georgia-Bold


 Font family name = Apple Color Emoji
 - Font name = AppleColorEmoji


 Font family name = Arial Rounded MT Bold
 - Font name = ArialRoundedMTBold


 Font family name = Kailasa
 - Font name = Kailasa-Bold
 - Font name = Kailasa


 Font family name = Kohinoor Devanagari
 - Font name = KohinoorDevanagari-Light
 - Font name = KohinoorDevanagari-Regular
 - Font name = KohinoorDevanagari-Semibold


 Font family name = Kohinoor Bangla
 - Font name = KohinoorBangla-Semibold
 - Font name = KohinoorBangla-Regular
 - Font name = KohinoorBangla-Light


 Font family name = Chalkboard SE
 - Font name = ChalkboardSE-Bold
 - Font name = ChalkboardSE-Light
 - Font name = ChalkboardSE-Regular


 Font family name = Sinhala Sangam MN
 - Font name = SinhalaSangamMN-Bold
 - Font name = SinhalaSangamMN


 Font family name = PingFang TC
 - Font name = PingFangTC-Medium
 - Font name = PingFangTC-Regular
 - Font name = PingFangTC-Light
 - Font name = PingFangTC-Ultralight
 - Font name = PingFangTC-Semibold
 - Font name = PingFangTC-Thin


 Font family name = Gujarati Sangam MN
 - Font name = GujaratiSangamMN-Bold
 - Font name = GujaratiSangamMN


 Font family name = Damascus
 - Font name = DamascusLight
 - Font name = DamascusBold
 - Font name = DamascusSemiBold
 - Font name = DamascusMedium
 - Font name = Damascus


 Font family name = Noteworthy
 - Font name = Noteworthy-Light
 - Font name = Noteworthy-Bold


 Font family name = Geeza Pro
 - Font name = GeezaPro
 - Font name = GeezaPro-Bold


 Font family name = Avenir
 - Font name = Avenir-Medium
 - Font name = Avenir-HeavyOblique
 - Font name = Avenir-Book
 - Font name = Avenir-Light
 - Font name = Avenir-Roman
 - Font name = Avenir-BookOblique
 - Font name = Avenir-Black
 - Font name = Avenir-MediumOblique
 - Font name = Avenir-BlackOblique
 - Font name = Avenir-Heavy
 - Font name = Avenir-LightOblique
 - Font name = Avenir-Oblique


 Font family name = Academy Engraved LET
 - Font name = AcademyEngravedLetPlain


 Font family name = Mishafi
 - Font name = DiwanMishafi


 Font family name = Futura
 - Font name = Futura-CondensedMedium
 - Font name = Futura-CondensedExtraBold
 - Font name = Futura-Medium
 - Font name = Futura-MediumItalic


 Font family name = Farah
 - Font name = Farah


 Font family name = Kannada Sangam MN
 - Font name = KannadaSangamMN
 - Font name = KannadaSangamMN-Bold


 Font family name = Arial Hebrew
 - Font name = ArialHebrew-Bold
 - Font name = ArialHebrew-Light
 - Font name = ArialHebrew


 Font family name = Arial
 - Font name = ArialMT
 - Font name = Arial-BoldItalicMT
 - Font name = Arial-BoldMT
 - Font name = Arial-ItalicMT


 Font family name = Party LET
 - Font name = PartyLetPlain


 Font family name = Chalkduster
 - Font name = Chalkduster


 Font family name = Hoefler Text
 - Font name = HoeflerText-Italic
 - Font name = HoeflerText-Regular
 - Font name = HoeflerText-Black
 - Font name = HoeflerText-BlackItalic


 Font family name = Optima
 - Font name = Optima-Regular
 - Font name = Optima-ExtraBlack
 - Font name = Optima-BoldItalic
 - Font name = Optima-Italic
 - Font name = Optima-Bold


 Font family name = Palatino
 - Font name = Palatino-Bold
 - Font name = Palatino-Roman
 - Font name = Palatino-BoldItalic
 - Font name = Palatino-Italic


 Font family name = Lao Sangam MN
 - Font name = LaoSangamMN


 Font family name = Malayalam Sangam MN
 - Font name = MalayalamSangamMN-Bold
 - Font name = MalayalamSangamMN


 Font family name = Al Nile
 - Font name = AlNile-Bold
 - Font name = AlNile


 Font family name = Bradley Hand
 - Font name = BradleyHandITCTT-Bold


 Font family name = PingFang HK
 - Font name = PingFangHK-Ultralight
 - Font name = PingFangHK-Semibold
 - Font name = PingFangHK-Thin
 - Font name = PingFangHK-Light
 - Font name = PingFangHK-Regular
 - Font name = PingFangHK-Medium


 Font family name = Trebuchet MS
 - Font name = Trebuchet-BoldItalic
 - Font name = TrebuchetMS
 - Font name = TrebuchetMS-Bold
 - Font name = TrebuchetMS-Italic


 Font family name = Helvetica
 - Font name = Helvetica-Bold
 - Font name = Helvetica
 - Font name = Helvetica-LightOblique
 - Font name = Helvetica-Oblique
 - Font name = Helvetica-BoldOblique
 - Font name = Helvetica-Light


 Font family name = Courier
 - Font name = Courier-BoldOblique
 - Font name = Courier
 - Font name = Courier-Bold
 - Font name = Courier-Oblique


 Font family name = Cochin
 - Font name = Cochin-Bold
 - Font name = Cochin
 - Font name = Cochin-Italic
 - Font name = Cochin-BoldItalic


 Font family name = Hiragino Mincho ProN
 - Font name = HiraMinProN-W6
 - Font name = HiraMinProN-W3


 Font family name = Devanagari Sangam MN
 - Font name = DevanagariSangamMN
 - Font name = DevanagariSangamMN-Bold


 Font family name = Oriya Sangam MN
 - Font name = OriyaSangamMN
 - Font name = OriyaSangamMN-Bold


 Font family name = Snell Roundhand
 - Font name = SnellRoundhand-Bold
 - Font name = SnellRoundhand
 - Font name = SnellRoundhand-Black


 Font family name = Zapf Dingbats
 - Font name = ZapfDingbatsITC


 Font family name = Bodoni 72
 - Font name = BodoniSvtyTwoITCTT-Bold
 - Font name = BodoniSvtyTwoITCTT-Book
 - Font name = BodoniSvtyTwoITCTT-BookIta


 Font family name = Verdana
 - Font name = Verdana-Italic
 - Font name = Verdana-BoldItalic
 - Font name = Verdana
 - Font name = Verdana-Bold


 Font family name = American Typewriter
 - Font name = AmericanTypewriter-CondensedLight
 - Font name = AmericanTypewriter
 - Font name = AmericanTypewriter-CondensedBold
 - Font name = AmericanTypewriter-Light
 - Font name = AmericanTypewriter-Bold
 - Font name = AmericanTypewriter-Condensed


 Font family name = Avenir Next
 - Font name = AvenirNext-UltraLight
 - Font name = AvenirNext-UltraLightItalic
 - Font name = AvenirNext-Bold
 - Font name = AvenirNext-BoldItalic
 - Font name = AvenirNext-DemiBold
 - Font name = AvenirNext-DemiBoldItalic
 - Font name = AvenirNext-Medium
 - Font name = AvenirNext-HeavyItalic
 - Font name = AvenirNext-Heavy
 - Font name = AvenirNext-Italic
 - Font name = AvenirNext-Regular
 - Font name = AvenirNext-MediumItalic


 Font family name = Baskerville
 - Font name = Baskerville-Italic
 - Font name = Baskerville-SemiBold
 - Font name = Baskerville-BoldItalic
 - Font name = Baskerville-SemiBoldItalic
 - Font name = Baskerville-Bold
 - Font name = Baskerville


 Font family name = Khmer Sangam MN
 - Font name = KhmerSangamMN


 Font family name = Didot
 - Font name = Didot-Italic
 - Font name = Didot-Bold
 - Font name = Didot


 Font family name = Savoye LET
 - Font name = SavoyeLetPlain


 Font family name = Bodoni Ornaments
 - Font name = BodoniOrnamentsITCTT


 Font family name = Symbol
 - Font name = Symbol


 Font family name = Menlo
 - Font name = Menlo-Italic
 - Font name = Menlo-Bold
 - Font name = Menlo-Regular
 - Font name = Menlo-BoldItalic


 Font family name = Bodoni 72 Smallcaps
 - Font name = BodoniSvtyTwoSCITCTT-Book


 Font family name = Papyrus
 - Font name = Papyrus
 - Font name = Papyrus-Condensed


 Font family name = Hiragino Sans
 - Font name = HiraginoSans-W3
 - Font name = HiraginoSans-W6


 Font family name = PingFang SC
 - Font name = PingFangSC-Ultralight
 - Font name = PingFangSC-Regular
 - Font name = PingFangSC-Semibold
 - Font name = PingFangSC-Thin
 - Font name = PingFangSC-Light
 - Font name = PingFangSC-Medium


 Font family name = Euphemia UCAS
 - Font name = EuphemiaUCAS-Italic
 - Font name = EuphemiaUCAS
 - Font name = EuphemiaUCAS-Bold


 Font family name = Telugu Sangam MN


 Font family name = Bangla Sangam MN


 Font family name = Zapfino
 - Font name = Zapfino


 Font family name = Bodoni 72 Oldstyle
 - Font name = BodoniSvtyTwoOSITCTT-Book
 - Font name = BodoniSvtyTwoOSITCTT-Bold
 - Font name = BodoniSvtyTwoOSITCTT-BookIt



 */
