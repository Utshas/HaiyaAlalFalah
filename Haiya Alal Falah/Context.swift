//
//  Context.swift
//  Haiya Alal Falah
//
//  Created by LumberMill on 2024/05/01.
//

import Foundation
import Adhan
enum PrayerCall: String {
    case azan = "Azan"
    case iqamah = "Iqamah"
    case none = "None"
}
class Context :NSObject{
    static let shared = Context()
    var city = "world"
    var lattitude = -200.0
    var longitude = -200.0
    var lastUpdatedNotifications:TimeInterval = 0
    var allPrayers: [PrayerTimes?] = []
    let motivational_ayats = [
        ["حَدَّثَنَا مُحَمَّدُ بْنُ بَشَّارٍ، حَدَّثَنَا غُنْدَرٌ، عَنْ عَبْدِ الرَّحْمَنِ بْنِ مَهْدِيٍّ، عَنْ أَبِي جَعْفَرٍ الرَّازِيِّ، عَنْ جَابِرِ بْنِ عَبْدِ اللَّهِ ـ رضى الله عنهما ـ قَالَ قَالَ رَسُولُ اللَّهِ صلى الله عليه وسلم ' بَيْنَ الرَّجُلِ وَبَيْنَ الشِّرْكِ وَالْكُفْرِ تَرْكُ الصَّلاَةِ '.", "Narrated Jabir bin 'Abdullah: Allah's Messenger (ﷺ) said, 'Between a man and disbelief and paganism is the abandonment of Salah (prayer).' [Sahih Muslim]"],
        ["                        حَدَّثَنَا أَبُو كُرَيْبٍ، حَدَّثَنَا رِشْدِينُ بْنُ سَعْدٍ، عَنْ عَمْرِو بْنِ الْحَارِثِ، عَنْ دَرَّاجٍ، عَنْ أَبِي الْهَيْثَمِ، عَنْ أَبِي سَعِيدٍ، قَالَ:‏‏‏‏ قَالَ رَسُولُ اللَّهِ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ:‏‏‏‏    إِذَا رَأَيْتُمُ الرَّجُلَ يَعْتَادُ الْمَسْجِدَ فَاشْهَدُوا لَهُ بِالْإِيمَانِ، ‏‏‏‏‏‏قَالَ اللَّهُ تَعَالَى:‏‏‏‏ إِنَّمَا يَعْمُرُ مَسَاجِدَ اللَّهِ مَنْ آمَنَ بِاللَّهِ وَالْيَوْمِ الآخِرِ سورة التوبة آية 18   .", "                         Narrated Abu Sa'eed:that the Messenger of Allah (ﷺ) said:   When you see a man frequenting the Masjid, then testify to his faith. Indeed Allah, Most High, said: The Masjid shall be maintained by those who believe in Allah and the Last day (9:18). "],
        ["عَنْ عَبْدِ اللَّهِ بْنِ قُرَافٍ، قَالَ قَالَ رَسُولُ اللَّهِ صلى الله عليه وسلم ‏ '‏ إِنَّ أَوَّلَ مَا يُحْشَرُ النَّاسُ إِلَيْهِ يَوْمَ الْقِيَامَةِ مِنْ عَمَلِهِمُ الصَّلاَةُ فَإِنْ صَلُحَتْ فَقَدْ أَفْلَحَ وَأَنْجَحَ وَإِنْ فَسَدَتْ فَقَدْ خَابَ وَخَسِرَ ‏'","Narrated Abdullah bin Quraaf: The Prophet (ﷺ) said, 'The first of man's deeds for which he will be called to account on the Day of Resurrection will be Salat. If it is found to be perfect, he will be safe and successful; but if it is incomplete, he will be unfortunate and a loser.' [Sunan Abu Dawood, tabarani]"],
        ["حَدَّثَنَا الْمُعْتَمِرُ، حَدَّثَنَا مُحَمَّدُ بْنُ عَبْدِ اللَّهِ بْنِ النَّمْلَةِ، عَنِ ابْنِ الْمُبَارَكِ، عَنْ مُحَمَّدِ بْنِ عَبْدِ الْمَلِكِ الأَنْصَارِيِّ، عَنْ أَبِي أُمَامَةَ، عَنْ الْحَكَمِ بْنِ مُعَاذٍ، عَنْ كَتَادَةَ، عَنْ أَنَسٍ، عَنْ النَّبِيِّ صلى الله عليه وسلم قَالَ 'مَنْ صَلَّى الْبَرْدَيْنِ دَخَلَ الْجَنَّةَ'.","Narrated Anas: The Prophet (ﷺ) said, 'Whoever observes the coldness of dawn (Fajr) and the afternoon (Asr) prayers will enter Paradise.'[Sahih al-Bukhari]"],
        ["قَالَ النَّبِيُّ صلى الله عليه وسلم : 'كُنْتُ أَخْطُبُ الْمُؤَذِّنَ أَنْ يُقِيمَ فَيُؤْمَرَ رَجُلٌ يَقْتَادُ الصَّلاَةَ، وَأَحْمِلَ عَلَى رِجَالٍ لاَ يَخْرُجُونَ إِلَى الصَّلاَةِ مَعَ النَّاسِ فَأُحَرِّقَ عَلَيْهِمْ بُيُوتَهُمْ'. [صحيح البخاري]", "The Prophet (peace be upon him) said, 'I had thought of ordering the Mu'addhin to pronounce Iqamah (call to start the prayer) and order a man to lead the prayer, and then take a fire flame to burn all those who had not left their houses so far for the prayer along with their houses.' [Sahih al-Bukhari]"],
        ["يَا أَيُّهَا الَّذِينَ آمَنُوا اسْتَعِينُوا بِالصَّبْرِ وَالصَّلَاةِ ۚ إِنَّ اللَّهَ مَعَ الصَّابِرِينَ","O you who have believed, seek help through patience and prayer. Indeed, Allah is with the patient. [Quran 2:153]"],
        ["قَدْ أَفْلَحَ الْمُؤْمِنُونَ ۝ الَّذِينَ هُمْ فِي صَلَاتِهِمْ خَاشِعُونَ", "Successful indeed are the believers. Those who offer their prayers with all solemnity and submissiveness. [Surah Al-A'raf: 14-15]"],
        ["اِنَّ الصَّلٰوةَ كَانَتۡ عَلَى الۡمُؤۡمِنِيۡنَ كِتٰبًا مَّوۡقُوۡتًا‏","Indeed, the prayer is obligatory upon the believers at prescribed times. [Surah An-Nisa: 103]"],
        ["فَوَيْلٌ لِّلْمُصَلِّينَ ۙ الَّذِينَ هُمْ عَن صَلَاتِهِمْ سَاهُونَ ۙ الَّذِينَ هُمْ يُرَاءُونَ","So troubles to those who pray [But] who are heedless of their prayer - Those who make show [of their deeds].[sura maun: 4-6]"],
        ["يٰٓاَيُّهَا الَّذِيۡنَ اٰمَنُوا اسۡتَعِيۡنُوۡا بِالصَّبۡرِ وَالصَّلٰوةِ ؕ اِنَّ اللّٰهَ مَعَ الصّٰبِرِيۡنَ‏ ","O believers! Seek comfort in patience and prayer. Allah is truly with those who are patient. [Sura Baqarah: 153]"],
        ["قُلْ لِّـعِبَادِىَ الَّذِيۡنَ اٰمَنُوۡا يُقِيۡمُوا الصَّلٰوةَ وَيُنۡفِقُوۡا مِمَّا رَزَقۡنٰهُمۡ سِرًّا وَّعَلَانِيَةً مِّنۡ قَبۡلِ اَنۡ يَّاۡتِىَ يَوۡمٌ لَّا بَيۡعٌ فِيۡهِ وَلَا خِلٰلٌ‏ ","Tell My believing servants to establish prayer and donate from what We have provided for them—openly and secretly—before the arrival of a Day in which there'll be no ransom or friendly connections. [Sura Ibrahim: 31]"],
        ["إِنَّنِي أَنَا اللَّهُ لَا إِلَٰهَ إِلَّا أَنَا فَاعْبُدْنِي وَأَقِمِ الصَّلَاةَ لِذِكْرِي","Indeed, I am Allah. There is no deity except Me, so worship Me and establish prayer for My remembrance. [Sura taha: 14]"]
    ]
}
