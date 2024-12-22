/**
 * Incomplete Notification API override to enable native notifications.
 */
class NotificationOverride {

    static get permission() {
        return "granted";
    }

    static requestPermission (callback) {
        callback("granted");
    }

    constructor (messageText, options) {
        window.webkit.messageHandlers.notify.postMessage(messageText + "|" + options.body);
    }
}

// Override the global browser notification object.
window.Notification = NotificationOverride;



// Р¤СѓРЅРєС†РёРё РґР»СЏ Advance mode

function eventFire(el, etype) {
    var evt = document.createEvent("MouseEvents");
    evt.initMouseEvent(etype, true, true, window,0, 0, 0, 0, 0, false, false, false, false, 0, null);
    el.dispatchEvent(evt);
}

function clickOnChatListItem(event) {
    event.target.click();
    eventFire(event.target, 'mousedown');

    // РњРµРЅСЏРµРј Р·РЅР°С‡РµРЅРёСЏ РЅР° РѕС‚РѕР±СЂР°Р¶РµРЅРёРµ С‚РѕР»СЊРєРѕ С‡Р°С‚Р°
    document.getElementsByClassName('_aigv _aigz')[1].style.display = 'block';

    document.getElementsByClassName('_aigv _aigz')[1].style.width = '\(UIScreen.main.bounds.width)px';
    document.getElementsByClassName('_aigv _aigz')[1].style.overflow = 'unset';
    document.getElementsByClassName('xa1v5g2 x1n2onr6 x9f619 x78zum5 x6s0dn4 xl56j7k xbyj736 x5yr21d x1ye3gou xn6708d x1acz5yr xm81vs4 xu3j5b3 x1a0jr7w')[0].style.display = 'none';
    document.getElementsByClassName('_aohf _aigv _aigw _aigx')[0].style.display = 'none';

    document.getElementsByClassName('_aigv _aigw')[1].style.display = 'none';
    document.getElementsByClassName('_aigv _aigz')[0].style.flexGrow = '1';

    for (let i = 0; i < 5; i++) {
        setTimeout(() => {
            var chatSpace = document.getElementsByClassName('x3psx0u xwib8y2 xkhd6sd xrmvbpv')[0];
            chatSpace.focus()
        }, 75)
    }

    setTimeout(() => {

        if (document.getElementById('backToChatsButton') == null) {
            // Р”РѕР±Р°РІР»СЏРµРј РєРЅРѕРїРєСѓ РґР»СЏ РІРѕР·РІСЂР°С‚Р° РІ СЃРїРёСЃРѕРє С‡Р°С‚РѕРІ

            var button = document.createElement('input');
            button.type = 'button';
            button.setAttribute('id', 'backToChatsButton');
            button.style.fontSize = '15pt';
            button.style.margin = '0';
            button.style.background = 'none';
            button.style.border = 'none';
            button.value = '<';
            button.onclick = function() {
                document.getElementsByClassName('_aigv _aigz')[1].style.display = 'none';

                // Р”РµР»Р°РµРј СЂР°Р·РјРµСЂ Р±Р»РѕРєР° СЃРѕ СЃРїРёСЃРєРѕРј С‡Р°С‚РѕРІ = СЂР°Р·РјРµСЂСѓ СЌРєСЂР°РЅР°
                document.getElementsByClassName('_aigv _aigw')[1].style.maxWidth = '\(UIScreen.main.bounds.width)px';
                document.getElementsByClassName('_aigv _aigw')[1].style.flex = 'auto';

                document.getElementsByClassName('_aigv _aigw')[1].style.display = 'block';
                document.getElementsByClassName('xa1v5g2 x1n2onr6 x9f619 x78zum5 x6s0dn4 xl56j7k xbyj736 x5yr21d x1ye3gou xn6708d x1acz5yr xm81vs4 xu3j5b3 x1a0jr7w')[0].style.display = 'flex';

                document.getElementsByClassName('_aigv _aigz')[0].style.flexGrow = 'inherit';

                document.getElementsByClassName('_aohf _aigv _aigw _aigx')[0].style.display = 'flex';
                
                if (document.getElementsByClassName('x78zum5 xdt5ytf x17qophe x6ikm8r x10wlt62 x67bb7w x13vifvy xm0mufa x1uoaltn x1itt0r x10l6tqk xh8yej3 _ahmw copyable-area').length > 0) {
                    document.getElementsByClassName('x1ypdohk')[0].click()
                } else if (document.getElementsByClassName('x1c4vz4f xs83m0k xdl72j9 x1g77sc7 x78zum5 xozqiw3 x1oa3qoh x12fk4p8 xeuugli x2lwn1j x1nhvcw1 xdt5ytf x1qjc9v5 _ajwt').length > 0) {
                    document.getElementsByClassName('xexx8yu x4uap5 x18d9i69 xkhd6sd xjb2p0i xk390pu x1heor9g x1ypdohk xjbqb8w x972fbf xcfux6l x1qhh985 xm0m39n')[0].click()
                }

            }

            var chatHeader = document.getElementsByClassName('_amid')[0];
            chatHeader.prepend(button);
        }
    }, 300)

}
