

# KireiShareView
Simple & Beautiful ShareView.

![Output sample](https://github.com/entotsu/KireiShare/blob/master/demo.gif?raw=true)


# How To Use
```
let shareView = KireiShareView(
    text: "Awesome!!Dope!!!",
    url: "http://uniface.in/",
    image: thumbnail
)
shareView.show()
```

# Optional Customization

## Custom Parameter
```
shareView.otherButtonTitle = "その他"
shareView.cancelButtonTitle = "キャンセル"
shareView.copyLinkButtonTitle = "リンクをコピー"
shareView.copyFinishedMessage = "コピーしました。"
shareView.animationDuration = 0.2
```

## Custom Button List
```
shareView.buttonList = [
    .Other,
    .CopyLink,
    .Facebook,
    .Twitter,
]
```

## Add Custom Button
```
shareView.buttonList = [
    .Other,
    .CopyLink,
    .Facebook,
    .Twitter,

    // add your button
    .Custom(
        title: "Tumblr",
        icon: UIImage(named:"tumblr"),
        onTap: {
            shareToTumblr()
            shareView.dismiss()
        }
    ),
]
```


-------------------------------------------------------------------------------------

Developer: [@tk_365](https://twitter.com/tk_365)

Designer: [@mackymakiosh](https://www.behance.net/mcky_mnml)
