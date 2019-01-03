//
//  Global.h
//  WoPay
//
//  Created by Peter on 11-9-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

//

extern NSInteger pindex;
extern NSString* LeYaotype;
extern NSInteger qiehuanlogin;

extern BOOL isJY;
extern BOOL isSF;
extern BOOL isBF;

//#define URL_PRE @"http://10.1.71.52:8080/hcy-system/"

//#define URL_PRE @"http://10.1.71.62:8080/healthlm/"

//#define URL_PRE @"http://119.254.24.4:7006/"



#define URL_PRE @"http://eky3h.com/healthlm/"
//#define URL_PRE @"http://10.1.71.104:8080/hcy/"



//#define URL_PRE22 @"http://10.1.71.50:8080/hcy/"
//#define URL_PRE22 @"http://10.1.71.104:8080/hcy/"
/*
 http://119.254.24.4:7006/          测试地址
 http://app.ky3h.com:8001/healthlm/ 正式地址
 */

#define testUUId 100002514
#define testToken  @"ECEEDCCD74B7D54BCF6690B7E26262B73F0D04F68EA2608F6783B874E4F50EEF"
#define testMedicId @"1541041785333"

//问卷类别sn
#define kBody @"TZBS"
#define kMental @"XLBS"
//#define URL_PRE @"http://liuzyx.vicp.cc:17001/taiping/voice";
//2014-10-23

/**
 * 档案接口
 */

/**
 * 经络接口
 */
#define MainAndCollateralChannels_url  @"/member/myreport/list/JLBS/9.jhtml?pageNumber="

/**
 * 体质接口
 */
#define Constitution_url         @"member/myreport/list/TZBS/24.jhtml?pageNumber="

/**
 * 脏腑接口
 */
#define InternalOrgans_url            @"/result/IdentificationList.jhtml?cust_id=24&pageNumber="

/**
 * 心率接口
 */
#define HeartRate_url                 @"/member/myreport/getEcgList/24.jhtml?pageNumber="


/**
 * 二十一个一的网址
 */

/**
 *  一戴
 */
#define BaseWebAdressYiDai @"/member/service/index/yidai/JLBS"
/**
 *  一听
 */
#define BaseWebAdressYiTing @"/member/service/index/yiting/JLBS"
/**
 *  一站
 */
#define BaseWebAdressYiZhan @"/member/service/index/yizhan/JLBS"
/**
 *  一贴
 */
#define BaseWebAdressYiTei @"/member/service/index/yitei/JLBS"
/**
 *  一选
 */
#define BaseWebAdressYiXuan @"/member/service/index/yixuan/JLBS"
/**
 *  一炶
 */
#define BaseWebAdressYiShan @"/member/service/index/yishan/JLBS"
/**
 *  一灸
 */
#define BaseWebAdressYiJiu @"/member/service/index/yijiu/JLBS"
/**
 *  一推
 */
#define BaseWebAdressYiTui @"/member/service/index/yitui/JLBS"
/**
 *  一刮
 */
#define BaseWebAdressYiGua @"/member/service/index/yigua/JLBS"
/**
 *  一吃
 */
#define BaseWebAdressYiChi @"/member/service/index/yichi/ZFBS"
/**
 *  一坐
 */
#define BaseWebAdressYiZuo @"/member/service/index/yizuo/ZFBS"
/**
 *  一饮
 */
#define BaseWebAdressYiYin @"/member/service/index/yiyin/TZBS"
/**
 *  一保
 */
#define BaseWebAdressYiBao @"/member/service/index/yibao/TZBS"
/**
 *  一助
 */
#define BaseWebAdressYiZhu @"/member/service/yizhu.jhtml"
/**
 *  一呼
 */
#define BaseWebAdressYiHu @"/member/service/yihu.jhtml"
/**
 *  一测
 */
#define BaseWebAdressYiCe @"/member/service/yice.jhtml?memberChildId="
/**
 *  一送
 */
#define BaseWebAdressYiSong @"/mobileIndex.html"
/**
 *  一点---体质辨识
 */
#define BaseWebAdressYiDian @"/member/service/index/yidian/TZBS"
/**
 *  一说---闻音辨识
 */
#define BaseWebAdressYiShuo @"/member/service/index/yishuo/JLBS"
/**
 *  一写---脏腑辨识
 */
#define BaseWebAdressYiXie @"/member/service/index/yixie/ZFBS"

#define jlbsAdvice @"评测一下，了解经络状态"
#define tzbsAdvice @"评测一下，了解体质状态"
#define zfbsAdvice @"评测一下，了解脏腑状态"

#define requestErrorMessage @"服务器开小差了,请稍后重试!"

// 心电数据保存路径
#define HealthDataPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HealthData.ecg"]

// 心电数据保存路径
#define uploadHealthData [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"uploadHealthData.ecg"]


#define AboutSportExplain @"一、	运动简介\n    和畅运动-八式（以下简称“和畅运动”）源于传统民俗健身法。传统民俗健身法中，拉脚筋具有防止筋骨僵硬，舒筋壮骨，使血液顺畅等各种健身功能。“和畅运动”在传统民俗健身方法的基础上，与传统功能锻炼方法相融合，使传统健身方法不再只是“拉脚筋”，而是升华为一种由外及里，由下至上的整体健身法，即通过拉伸人体表面的经筋，从而使人体经络畅达，气血运行回归正常状态，脏腑受到足够的滋养，脏腑功能强健，最终使人体感到轻松、舒畅。\n二、运动原理\n    人体是由五脏六腑、四肢百骸、五官九窍、皮肉筋骨等所组成，这些脏器组织虽然各有不同生理功能，但又是相互协作，并保持协调和统一的。这种机能活动的协调统一，主要是通过经络系统的联络作用而实现的。经络将人体的气血不断的输布给五脏六腑，使脏腑正常工作；脏腑不断工作生成的气血又通过经络储存起来，或散布到四肢百骸，维持人体的生命形式。因此，只有经络畅通，才能使脏腑强壮，从而使人体耳聪目明、精神爽朗、健康长寿。《灵枢·根结》记载了足三阴三阳的根与结。马玄台注：“脉气所起为根，所归为结”。根为本，结为标。足之三阴三阳经之根皆在足部。足太阳经之根，以至阴为穴；足少阳经之根，以窍阴为穴；足阳明经之根，以厉兑为穴；足太阴经之根，以隐白为穴；足厥阴经之根，以大敦为穴；足少阴经之根，以涌泉为穴。站立于“和畅依”上，可使二足根穴经气激发。配套的“和畅运动”，可针对性的锻炼不同的经脉。二者配合共同发挥疏通经脉，调其气血，畅达经气，加强脏腑功能的作用。民间俗称“筋长一寸，寿延十年”。经筋是经络系统的重要组成部分，是十二经脉在肢体外周的连属部分，亦即十二经脉之气“结、聚、散、络”于筋肉关节的体系。明代医学家张介宾提到：“十二经脉之外而复有经筋者，何也？盖经脉营行表里，故出入脏腑，以次相传；经筋联缀百骸，故维络周身，各有定位。虽经筋所盛之处，则唯四肢溪谷之间为最，以筋会于节也。筋属木，其华在爪，故十二经筋皆起于四肢指爪之间，而后盛于辅骨，结于肘腕，系于关节，联于肌肉，上于颈项，终于头面，此人身经筋之大略也”。使用“和畅运动”进行功能锻炼，能够拉抻人体的经筋，增加筋的柔韧性，延缓因衰老引起的筋缩，达到所谓骨正筋柔，气血自流。\n三、运动特点\n    “和畅运动”是一项通过器材与经络操相结合达到疏通经络，强身健体的作用，并在此基础上起到预防疾病的一种新型锻炼项目。“和畅运动”最大的优势在于对场地没有特殊要求，与之相配套的功法通过不同角度的调试达到疏通经络，治疗疾病的效果。“和畅运动”配套的八节功能锻炼，通过不同的动作，分别畅通人体非常重要的肺经、肾经、胆经与脾经。“和畅依”具有六种可调节的倾角，人即使是仅仅站立在板面上，也能够充分且循序渐进地激发足部根穴经气：足少阳胆经之足窍阴穴；足阳明胃经厉兑穴；足太阴脾经之隐白穴；足厥阴肝经之大敦穴；足少阴肾经之涌泉穴。足部发力的同时，直接拉伸了人体从小腿后部、大腿、腰、背部、颈、头部的足太阳膀胱经。足太阳膀胱经起于目内眦睛明穴，止于足小趾至阴穴，左右对称，每侧67个穴位，是十四经中穴位最多的一条经。尤其是背部的膀胱经，夹脊柱两旁，分布着人体所有的背俞穴。背俞穴与五脏六腑相呼应，拉抻膀胱经，可以调理机体心、肝、脾、肺、肾五脏及小肠、胆、胃、大肠、膀胱、三焦六腑，解决呼吸系统、消化系统、心脑血管的相关疾病；此外，由于其循行于脊椎两侧，还可以有效改善颈椎病、背肌劳损、腰肌劳损、腰椎间盘突出症等脊椎部疾病。“和畅运动”运动锻炼方法，是对中国古人智慧的传承与发扬，在疑难杂症如此繁多的今天，通过对“筋”的锻炼，可以提高人体对各种疾病的反抗能力，因为无论是什么疾病，其根本病因在于经络不通，气血运行受阻，脏腑功能衰败，所以通过对“筋”的锻炼，可以由外及里，先后对经筋、经络、气血、脏腑造成良性影响，从而达到人体整体的健身作用。"
#define AboutLeMedicineExplain @"一、乐药简介\n    “乐药”是指以传统医学与音律学为理论基础，筛选中国古代器乐名曲，并进行调式的划分，依据徵音躁急动悸像火、羽音悠远像水、宫音浑厚温和像土、商音凄切悲怅像金、角音清脆激扬像木的特性，对个体人失衡的经络脏腑进行个性化调理的音乐养生方法。 \n二、乐药缘起\n    “药”字的古体为“藥”，为“乐（樂）”字加草字头。古人认为音乐与健康有密切的关联，“乐药”的说法渊源颇久，最早源自春秋时代，后在《黄帝内经》中开始有了系统的论述，基于五音与五行、五脏相属相依，跟据五行相生、相克理论，即可按照调式的划分，制定“乐药”的调治原则，从而实现个性化的音乐调理。早在春秋时代, 鲁昭公元年( 公元前541 年) , 晋平公得病, 求医于秦,秦人医和前往治疗时就对音乐与健康的关系有过深刻的论述, 他明确的指出什么样的音乐对身心健康有利, 而什么样的音乐对身心健康有害。秦人医和提倡的节,就是在声音和情绪上有节制的音乐,就是不要听“五降之后”、“繁于淫声”等那些没有节制的音乐。秦人医和可以说是我国历史上有纪载的最早音乐治疗专家。我国的思想家、教育家孔子,也是一位能弹琴会唱歌的音乐家。他提倡“和乐”,主张音乐以“中声为节”，也就是“乐而不淫”、“哀而不伤”,他提倡以尽善尽美的音乐,通过礼、乐,以达到“正心”、“修身”、“齐家”、“治国”、“平天下”的目的,认为音乐与身心健康密切相关。孔子指出“移风易俗,莫过于乐”说明音乐有利于创造美好、和谐的社会环境,和谐的环境是一个人身心健康的前提。《庄子》中提出“无听之以耳,而听之以心；无听之以心，而听之以气”，对音乐欣赏心理具有参考价值,对那些为达到放松、入境和心理调节为目的的音乐, 往往需要这样的欣赏心理。荀子的“乐言,是其和也”、“乐也者,和之不可变也”等论述, 也给音乐治疗研究和治疗音乐的编创提供了宝贵的参考资料。三国以后,被称为竹林七贤的嵇康,不仅是个文学家、书画家，而且善于弹琴。他的著作中有很多关于音乐的论述,对于音乐养生和音乐治疗都有参考价值。他在《声无哀乐论》中说:“躁静者,声之功也；哀乐者,情之主也”、“声音之体尽于舒疾,情之应声亦止于躁静”，说明节奏不同的音乐,可以对人情志的调节产生不同的效果。\n三、乐药原理\n    音乐疗法是音乐艺术与医学、心理学、物理学等多种学科交叉综合的应用，它主要通过音乐的旋律、节奏、和声、调式以及音的强弱及其组合来治疗疾病，使患者在治疗师的共同参与下，通过各种专门设计的音乐行为，经历音乐体验，达到消除心理障碍，恢复或增进身心健康的目的。利用音乐治疗疾病早在中医学经典著作《黄帝内经》中已有论及，中国传统音乐分为宫、商、角、徵、羽五种调式，中医学认为“宫动脾、商动肺、角动肝、徽动心、羽动肾”，即五音的特性与人体脾、肺、肝、心、肾五脏相对应，直接或间接影响人的情绪和脏腑功能。临床可根据这五种调式音乐的特性与五脏五行的关系及病人的不同心理状态来选定曲目治疗疾病，从而形成了中医传统音乐疗法。\n四、乐药历史\n    我国的思想家、教育家孔子,是一位音乐家,也是一位能弹琴会唱歌的音乐家。他提倡“和乐”,主张音乐以“中声为节”，也就是“乐而不淫”、“哀而不伤”,他提倡以尽善尽美的音乐,通过礼、乐,以达到“正心”、“修身”、“齐家”、“治国”、“平天下”的目的,认为音乐与身心健康密切相关。孔子指出“移风易俗,莫过于乐”说明音乐有利于创造美好、和谐的社会环境,和谐的环境是一个人身心健康的前提。《庄子》中提出“无听之以耳,而听之以心；无听之以心，而听之以气”，对音乐欣赏心理具有参考价值,对那些为达到放松、入境和心理调节为目的的音乐, 往往需要这样的欣赏心理。荀子的“乐言,是其和也”、“乐也者,和之不可变也”等论述, 也给音乐治疗研究和治疗音乐的编创提供了宝贵的参考资料。三国以后,被称为竹林七贤的嵇康,不仅是个文学家、书画家，而且善于弹琴。他的著作中有很多关于音乐的论述,对于音乐养生和音乐治疗都有参考价值。他在《声无哀乐论》中说:“躁静者,声之功也；哀乐者,情之主也”、“声音之体尽于舒疾,情之应声亦止于躁静”，说明节奏不同的音乐,可以对人情志的调节产生不同的效果。"
#define ExchangeNote @"每实现1分钟有效锻炼时长，即获得1分，积分每累计到达200分，即可获赠1次免费闻音辨识服务。"
#define MoreProduct @"    ◇ 24小时电话医生服务。通过拨打中国太平全国统一客服热线95589，为VIP客户或其家人提供7*24小全面的医疗、健康电话咨询服务。\n\n    ◇ 国内紧急医疗救援。在遭遇意外伤害或突发疾病的紧急医疗情况下，只需拨打中国太平全国统一客服热线95589，公司将为客户提供一系列医疗救援帮助服务。\n\n    ◇ 住院探视服务。如客户或保单被保险人因疾病或意外伤害进行住院治疗，收到住院消息后，我们将安排工作人员前往医院，对客户进行关怀探望，祝福早日康复出院。\n\n    ◇ 国内第二诊疗意见。在客户罹患疾病或遭受意外伤害，并已经获得医生第一诊疗意见的基础上，根据客户提供的完整的医疗资料，我们将安排国内相关专业的知名专家，评估客户的医疗资料，出具一份书面的医疗建议供参考，协助确定诊断及下一步治疗方案。\n\n    ◇ 专家门诊预约。如客户有门诊就医需求，太平人寿可提供合作知名医院的专家门诊预约及特需门诊预约服务。服务区域涵盖包括北京、上海、广州、成都四个拥有最丰富医疗资源的重点城市在内的33个大城市200余家知名医疗机构，服务网络丰富，形成了高水平的医疗网络和快速响应的服务平台。\n\n    ◇ 中西医上门服务。根据客户需求，太平人寿为客户提供约定城市内的、具有从业资质的医生上门提供一些基本的医疗服务，以节约就医时间，并提供私密尊贵的就医享受。\n\n    ◇ 健康关怀体检、健康尊享体检。公司各机构在当地精心挑选优质的合作体检机构，为客户安排每年一次约定体检套餐的体检服务。\n\n    ◇ 国内顶级体检服务。公司精心为客户甄选各地知名医院或知名体检机构，提供约定体检套餐的全方位高端体检服务。\n\n    ◇ 东南亚体检就医服务。公司甄选优质海外医疗资源，为客户搭建海外体检就医平台。根据客户服务需求，提供在东南亚约定合作医疗体检机构范围内的医疗体检服务。\n\n    ◇ 协助住院安排服务。当客户经医生诊断需要住院治疗，且医生已为其开具了入院单的情况下，公司将根据客户就诊需求，提供合作医院范围内的床位安排、入院手续协办等服务，优先办理住院手续。\n\n    ◇ 协助手术安排服务。当客户经医生诊断需要手术治疗的情况下，根据客户的实际需求，提供合作医院范围内的手术安排服务。\n\n    ◇ 海外第二诊疗意见服务。在客户罹患疾病或遭受意外伤害并已经通过就诊获得第一医疗意见基础上，如希望得到由海外权威医疗机构专家的进一步确诊、或期望得到海外权威医疗机构专家的后续治疗建议，在客户提出申请的情况下，公司为客户安排的由海外相关专业医疗专家，参考客户提供的相关诊疗资料，出具专业书面医疗建议的服务。\n\n    ◇ 海外就医安排服务。在客户罹患疾病或遭受意外伤害时，或在收到海外第二诊疗意见之后，拟前往海外就诊，在收到客户的服务需求申请后，太平人寿可协助为其安排海外的医疗专家门诊预约及安排医疗机构的住院床位。\n\n    如您对以上服务项目有任何疑问或任何需求，可咨询您的保单服务人员，或登录太平保险集团官网www.cntaiping.com进入“太寿网上营业厅-VIP会员尊享”了解。本公司保留对各项健康管理服务项目及服务对象调整和解释的权利。”"
#define HealthSpace @"    健康空间是为个人客户提供健康信息维护与个性化健康管理的综合服务平台，服务内容主要以自我健康管理和定向性推送健康文化为服务主线，并辅以健康保险、优生优育，健康宝箱、专家咨询等特色服务模块，以满足个体人不断提升健康状态的服务需求。\n    请将个人信息补充完成。点击“申请开通”后，我们将在24小时内进行审核，审核成功后，您将收到1条提示短信，按短信提示内容即可登录www.eky3h.com网站，享受更多专属健康管理服务。”"
#define weiboSpace @"    炎黄东方（北京）健康科技有限公司始建于2006年，作为国家“治未病”健康工程的发起和实施单位，积极组建“治未病战略联盟管理总部”，联合全国参与实施“治未病”健康工程的各类机构，共同构建中医特色预防保健服务体系，并创造性地提出了中医特色健康保障服务[知己（KY3H）服务]，倡导并遵循“管理风险、固本治本、提升状态”的服务理念，为客户提供因时间、因地域及其（因）场所和因人而异“四因制宜”的健康保障服务。\n    欢迎关注。"

#define CommonProblem @"A1：闻音文件上传失败怎么办？\nQ1：闻音文件上传失败往往和您当时所处的网络环境不理想有关，未成功上传的声音文件已存入“更多”的“闻音文件”中，您可在网络条件良好时重新上传，或选择删除此前文件，再次辨识。\n\nA2：闻音文件上传后未及时收到报告怎么办？\nQ2：闻音文件上传后，会有一个评估分析的过程，一般需要3-5分钟，请您耐心等待，报告回传成功后，本软件将自动触发提示信息。如10分钟以后您仍未收到报告，本软件将提示“闻音文件分析失败，请您重新辨识”。\n\nA3：注册帐号可在炎黄旗下其它应用中使用？\nQ3:：炎黄旗下的所有App都可以使用同一个注册帐号进行登录操作。"
#define AboutWe @"    一、	关于我们\n    炎黄东方(北京)健康科技有限公司（下称“炎健公司”）是2006年6月在北京注册的高新技术企业。公司总部位于北京，下设北京、上海、广东、浙江等多家分支机构。\n    愿景：打造昆仑－炎黄健康产业集团\n    使命：成为中国特色健康服务业发展的引领者\n    核心价值观：厚德·和合·知已\n\n    二、	核心理念\n    秉持“以人为本，以人的健康状态为中心，使人人享有效果和经济上可持续的健康”的理念，将“治未病”这一传统医学理念融合于当代人的健康保障需求之中。创造性地提出了中医特色健康保障服务[简称“知己（KY3H）服务”]，倡导并遵循“管理风险、固本治本、提升状态”的服务理念，为客户提供因时间、因地域及其（因）场所和因人而异“四因制宜”的健康保障服务。\n\n    三、	核心技术及产品\n    公司自成立之日起一直致力于创新研发，坚持以传统中医理论为基础，整合现代医学、生物医学工程、电子技术等现代科技成果，开发出多项具有自主知识产权的核心技术及产品，已取得多项国家专利。\n    已开发完成的服务技术产品包括KY3H体质辨识-评估-干预系统、KY3H证素辨识-评估-干预系统、KY3H闻音辨识-评估-干预系统、平和源系列体质调理食品、经络调理磁疗敷贴等健康干预产品。KY3H模式系列产品的推出，全面满足了广大消费者对“治未病”的健康管理服务需求，受到市场的热烈欢迎。\n\n    四、	科研积累\n    公司注重科研技术的开发与积累，联合数十位国家级名老中医、两院院士成立“治未病”专家委员会，组建由多名医学博士、硕士组成的研发团队，持续积极的参与国家“十一五”、“十二五”科技支撑计划、863计划的科研项目，取得和积累了多项科研成果。\n    同时与全国众多科研单位、医疗机构、高等院校建立了合作关系，建立虚拟治未病研究院，共同开展“治未病”技术及产品的研发。\n    经过多年不懈努力，不断创新研发，逐步形成了集产、学、研为一体的综合性“治未病”服务提供机构，未来公司将不断推出满足民众日益提升的对“治未病”文化、技术、产品、服务多方面需求的各类产品，为民众不生病、少生病、迟生病，提高生存质量而不懈努力。\n\n    五、社会实践\n    公司积极投身于国家中医药管理局在全国开展的“治未病”健康工程，并在国家中医药管理局“治未病”领导小组的领导下，组建“治未病战略联盟管理总部”，作为国家“治未病”健康工程的发起和实施单位，联合全国参与实施“治未病”健康工程的各类机构，共同构建中医特色预防保健服务体系。\n    近年来，围绕国家“治未病”健康工程的实施与开展，公司通过提供中医特色健康保障服务模式及项下服务技术产品，为各级医疗卫生、妇幼、健康机构开展中医特色预防保健服务提供全面解决方案，客户群覆盖全国主要大中城市专业医疗机构、社区卫生服务中心。\n    2009年至2011年，先后成功在上海市长宁区、北京市西城区、杭州市拱墅区建立“治未病”示范区，运用中医特色健康保障服务，为全区民众提供健康辨识、干预服务，覆盖人群近20万人，知己（KY3H）服务得到了社会的广泛认同。\n\n    公司通信信息：\n    全国统一客服中心：（86）400-6776-668 \n    邮箱： ky3h@ky3h.com \n    传真：（86）010-57591880 \n    地址：北京市朝阳区朝阳公园路19号，佳隆国际大厦A座九层"
#define Disclaimer @"    一旦您使用本软件，即表示您愿意接受以下条约。 \n    1、	您同意尽您最大的努力来防止和保护未经授权的发表和使用本软件程式及其文件内容，我们将保留所有无明确说明的权利。 \n    2、	本软件致力于健康调理，提供正确、完整的健康资讯，但不保证信息的正确性和完整性，且不对因信息的不正确或遗漏导致的任何损失或损害承担责任。\n    3、	经络健康调理产品所有功能之保证，已提供于软件内，没有任何其他额外保证。其他任何经络健康调理产品未提供之功能、品质或损及您其他之权益均非经络健康调理产品之保证范围。 \n    4、	本软件所提供的任何信息仅供个人健康管理参考，不能替代医生和其他医务人员的建议和诊断，不做个别诊断、用药和使用的根据，如自行使用本软件资料发生偏差，本公司概不负责，亦不负任何法律责任。 \n    5、	未经授权，本软件严禁用于任何形式的商业用途。\n    6、	如您认为本软件内容有侵权嫌疑，敬请立即通知我们，并告知侵权条款及依据，我们将在第一时间予以更改或删除同时本软件的原始版本不允许被误传。\n    7、	本软件著作权人为本软件作者，本软件、免责声明最终解释权归本软件作者所有。在未获得炎黄东方（北京）健康科技有限公司事先发放的书面许可情况下，任何个人或组织，均不得为任何目的，以任何形式对本产品及其配套资料的全部或部分内容进行复制、编译、反向工程、修改、传播、贩卖，及用于任何非法活动。对从事上述活动的当事人或组织，炎黄东方（北京）健康科技有限公司保留追究其法律责任的全部权利。"

#define RegistText @"    炎黄东方（北京）健康科技有限公司拥有对“和畅行”个体人经络状态调理系统及其所有相关印刷品、音像制品的全部知识产权。本产品受中华人民共和国相关法律保护，该产品用于进行知己KY3H闻音辨识、获取个性化《辨识报告》和《调理建议》、下载并收听情志调理“乐药”、自助管理经络调理运动行为等。"
#define BaoGaostr @"解析：\n      宫、商、角、徵、羽源于《黄帝内经》中的五音,以各自五行属性,对应五脏.根据每个音又形成5种状态,其中大宫音对应身体左侧足阳明胃经的功能失调.\n      此经络功能失调,可导致高血压、肺心病、慢性胃炎等慢性疾病的发生发展和变化."
#define BianShiInstruction @"    1、请在安静的室内环境中进行闻音辨识，并保持自身处于平静状态十分钟左右。\n    2、将手机置于面部正前方15cm左右，点击“开始辨识”\n    3、请用自然的语音语调，依次读取屏幕方框中显示的5个汉字—— 哆、来、咪、嗦、啦， 字与字之间略停顿。\n    4、5个汉字读取完毕后，系统将自动保存声音，并将数据上传，进行分析。\n    5、声音上传至分析结果返回系统，一般需要1分钟左右的时间，结果返回后，系统会有提示，完整的《辨识报告》和《调理建议》请到“报告”栏目中查看。\n    6、如声音文件上传失败，系统将提示您“声音文件不合格，请重新录音”或“上传文件失败，请通过“更多”栏中“未上传文件”再次上传。如遇声音上传失败的情况，请您检查手机的网络是否畅通，同时建议您重新录音完成辨识。"
#define BaoGaoInstruction @"	报告分为《辨识报告》和《调理建议》两部分。《辨识报告》中“状态结论”是提示您目前经络状态的辨识结论，及此种状态下导致的风险疾病种类。《调理建议》包括个性化的经络功能锻炼方法-“和畅运动八式”、情志调理音乐-“乐药”等。"
#define GongFaInstruction @"	和畅运动源于传统健身功法，共有8式。其是在经络脏腑气血盈亏的适宜时辰，通过和畅依保持特定站姿，完成相应动作，实现对不同经络的拉伸与锻炼，从而达到疏通经脉，调和脏腑的功效。\n	详细介绍请参见“更多”。"
#define YueYaoInstruction @"	“乐药”是指以传统医学与音律学为理论基础，筛选中国古代器乐名曲，并进行调式的划分，依据徵音躁急动悸像火、羽音悠远像水、宫音浑厚温和像土、商音凄切悲怅像金、角音清脆激扬像木的特性，对个体人失衡的经络脏腑进行个性化调理的音乐养生方法。\n		请您在收到报告后，根据报告中《调理建议》的提示，选择相应的乐药进行倾听，以便获得最佳调理效果。\n	详细介绍请参见“更多”。";
#define changeInstruction @"	如您的“和畅依”不幸损毁，我们将按照售后服务条款为您进行维修或更换，由此可能会导致您之前的注册证号失效，请按照最新注册证号（更换时配套提供）重新进行软件信息绑定。"
#define RegistrationInstruction @"	如何获取注册码？\n	注册码标注在“和畅依”《产品手册》封底。"

#define MianZeInstruction @"	炎黄东方（北京）健康科技有限公司拥有对“和畅依”个体人经络状态调理系统及其所有相关印刷品、音像制品的全部知识产权。本产品受中华人民共和国相关法律保护，每台产品拥有一个唯一注册码，该注册码只允许注册最多3个手机客户端应用软件，用于进行知己KY3H闻音辨识、获取个性化《辨识报告》和《调理建议》、下载并收听情志调理“乐药”、自助管理经络调理运动行为等。";
#define kVerRounterUrl @"http://123.125.97.241:8083" //测试环境   生产环境打包时请把这一行注释掉
#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0 ? YES : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

