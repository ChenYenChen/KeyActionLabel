# KeyActionLabel
swift Label 關鍵字點擊
![img](https://github.com/ChenYenChen/KeyActionLabel/blob/master/KeyWord.gif)
- 使用KeyActionLabel
```
@IBOutlet weak var actionLabel: KeyActionLabel!
```
- 建立字串及關鍵字
```
self.actionLabel.creatTabAction(title: "這是一個觸發點擊關鍵字的Label  線上 swift 讀書會 破2000人了(撒花 ～ 如果喜歡讀書會 再幫忙到粉絲團給個 5 star ", fontSize: 17, color: UIColor.brown, keyword: ["關鍵字", "2000人"], keywordColor: UIColor.red) { (index) in
            
            let alert = UIAlertController(title: "觸發", message: index == 0 ? "關鍵字" : "2000人", preferredStyle: .alert)
            let button = UIAlertAction(title: "確定", style: .default, handler: nil)
            alert.addAction(button)
            self.present(alert, animated: true, completion: nil)
        }
```
