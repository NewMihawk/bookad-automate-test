*** Variables ***
# Login page elements
${LOGIN_BUTTON}              //a[contains(text(), 'เข้าสู่ระบบ')] | //button[contains(text(), 'เข้าสู่ระบบ')] | //*[@id='login'] | //*[contains(@class, 'login')]
${LOGIN_FORM}                //form[contains(@class, 'login')] | //*[@id='login-form'] | //div[contains(@class, 'login-form')]
${USERNAME_INPUT}            //input[@type='email'] | //input[@name='email'] | //input[@name='username'] | //input[@id='email'] | //input[@id='username']
${PASSWORD_INPUT}            //input[@type='password'] | //input[@name='password'] | //input[@id='password']
${LOGIN_SUBMIT_BUTTON}       //button[@type='submit'] | //button[contains(text(), 'เข้าสู่ระบบ')] | //input[@type='submit']
${ERROR_MODAL}               //div[contains(@class, 'modal')] | //div[contains(@class, 'alert')] | //div[contains(@class, 'error')] | //div[contains(@role, 'alert')]
${ERROR_MESSAGE}             //*[contains(text(), 'The email or password provided is incorrect')] | //*[contains(text(), 'email or password')] | //*[contains(text(), 'incorrect')]

# Product/Cart elements
${FIRST_ITEM}                //div[contains(@class, 'product')]//a | //div[contains(@class, 'item')]//a | //article//a | (//a[contains(@href, 'product')])[1]
${ADD_TO_CART_BUTTON}        //button[contains(text(), 'เพิ่ม')] | //button[contains(text(), 'Add')] | //button[contains(@class, 'add-to-cart')] | //*[@id='add-to-cart']
${CART_ICON}                 //a[contains(@href, 'cart')] | //*[@id='cart'] | //*[contains(@class, 'cart')] | //*[contains(@class, 'shopping-cart')]
${CART_ITEM}                 //div[contains(@class, 'cart-item')] | //tr[contains(@class, 'cart-item')]
${CART_DELETE_BUTTON}        //h5[contains(@class,'cursor-pointer') and contains(@class,'text-error-500') and (contains(normalize-space(.), 'ลบ') or contains(normalize-space(.), 'Delete'))] | //*[(self::button or self::a or self::div or self::span or self::h5) and contains(@class,'cursor-pointer') and contains(@class,'text-error-500') and (contains(normalize-space(.), 'ลบ') or contains(normalize-space(.), 'Delete'))]
${DELETE_CONFIRM_BUTTON}     //button[contains(normalize-space(.), 'ยืนยัน')] | //button[contains(text(), 'ยืนยัน')] | //button[contains(normalize-space(.), 'Confirm')] | //button[contains(text(), 'Confirm')]
${CART_SELECT_ITEM}          (//input[@type='checkbox'])[1] | (//span[contains(@class,'checkbox')])[1] | (${CART_ITEM})[1]
${BOOK_QUEUE_BUTTON}         //button[contains(normalize-space(.), 'จองคิว')] | //a[contains(normalize-space(.), 'จองคิว')] | //button[contains(normalize-space(.), 'Book') and contains(normalize-space(.), 'Queue')]
${BRIEF_SELECT_TRIGGER}      //button[contains(normalize-space(.), 'เลือกบรีฟ')] | //button[contains(normalize-space(.), 'เลือก Brief')] | //button[contains(normalize-space(.), 'Brief')] | //button[@aria-haspopup='listbox']
${BRIEF_OPTION_FIRST}        (//li[@role='option' and not(contains(@class,'disabled'))])[1] | (//*[@role='option' and not(contains(@class,'disabled'))])[1]
${BRIEF_CONFIRM_BUTTON}      //button[contains(normalize-space(.), 'ยืนยัน')] | //button[contains(normalize-space(.), 'Confirm')]
${GOODDAY_OFFICIAL_TEXT}     //p[normalize-space(.)='GoodDay Official'] | //p[contains(@class,'text-body1') and normalize-space(.)='GoodDay Official'] | //div[contains(@class,'absolute') and contains(@class,'bottom-0')]//p[normalize-space(.)='GoodDay Official']
${VIEW_CHANNEL_DETAILS_BUTTON}    //button[normalize-space(.)='ดูรายละเอียดช่อง'] | //button[contains(normalize-space(.), 'ดูรายละเอียดช่อง')]
${GOODDAY_VIEW_DETAILS_BUTTON}    //p[normalize-space(.)='GoodDay Official']/ancestor::div[contains(@class,'absolute') and contains(@class,'bottom-0')]//button[contains(normalize-space(.), 'ดูรายละเอียดช่อง')]
${PROGRAM_GRID}              //div[contains(@class,'grid') and contains(@class,'grid-cols-3')]
${FIRST_PROGRAM_CARD}        (//div[contains(@class,'video-card-wrapper') and contains(@class,'cursor-pointer')])[1] | (//div[contains(@class,'group/card') and contains(@class,'cursor-pointer')])[1]
${KODEY_TEXT}                //h5[normalize-space(.)='Kodey'] | //div[@data-loaded='true']//h5[normalize-space(.)='Kodey']
${KODEY_CLICKABLE}           //div[contains(@class, 'group')][.//h5[contains(text(), 'Kodey')]] | //div[@data-loaded='true'][.//h5[contains(text(), 'Kodey')]] | //h5[contains(text(), 'Kodey')]/ancestor::div[contains(@class, 'group')] | //h5[contains(text(), 'Kodey')]

# Datepicker / on-air selection elements
${DATEPICKER_TRIGGER}        //button[@data-slot='trigger'][@aria-haspopup='listbox'] | //button[@data-slot='trigger'][.//span[@data-slot='value']] | //button[@type='button'][@aria-haspopup='listbox'][.//span[contains(@class,'value')]]
${ON_AIR_DATE_LIST}          //div[contains(@class,'on-air-selection-list')]
${ON_AIR_DATE_ITEM_ALL}      //div[contains(@class,'on-air-selection-item')]
${ON_AIR_DATE_ITEM_ENABLED}  //div[contains(@class,'on-air-selection-item') and not(contains(@class,'disabled'))]
${DATEPICKER_NEXT_BUTTON}    //div[contains(@class,'cursor-pointer') and contains(@class,'rounded-full') and contains(@class,'rotate-[270deg]')][.//img[contains(@src,'ico-chevron-down') or contains(@src,'chevron')]]

# Advertisement selection elements
${ADVERTISMENT_OPTION}        //div[contains(@class,'cursor-pointer')][contains(@class,'border')][.//h6[contains(text(),'60-Second Advertisement Spot')]] | //div[contains(@class,'border-gray-300')][.//h6[contains(text(),'Advertisement')]] | //div[contains(@class,'rounded-lg')][.//h6[contains(text(),'Advertisement Spot')]]
${ADD_TO_CART_FINAL_BUTTON}  //button[contains(text(),'เพิ่มไปยังตะกร้า')] | //button[contains(text(),'เพิ่มไปยังตระกร้า')] | //button[contains(text(),'Add to Cart')] | //button[@type='button'][contains(text(),'เพิ่ม')]

# Checkout/Order elements
${CHECKOUT_BUTTON}           //button[contains(text(), 'สั่งซื้อ')] | //button[contains(text(), 'Checkout')] | //a[contains(text(), 'Checkout')] | //*[@id='checkout']
${PLACE_ORDER_BUTTON}        //button[contains(text(), 'ยืนยัน')] | //button[contains(text(), 'Place Order')] | //button[contains(text(), 'Confirm')] | //*[@id='place-order']
${ORDER_SUCCESS_MESSAGE}     //div[contains(text(), 'สำเร็จ')] | //div[contains(text(), 'Success')] | //div[contains(text(), 'ขอบคุณ')] | //div[contains(text(), 'Thank you')]

# Brief/Campaign creation elements
${CREATE_BRIEF_BUTTON}       //button[contains(text(), 'สร้างบรีฟ')] | //button[contains(text(), 'Create Brief')] | //button[contains(text(), 'สร้าง Brief')] | //a[contains(text(), 'สร้างบรีฟ')] | //a[contains(text(), 'Create Brief')] | //a[contains(text(), 'สร้าง Brief')] | //*[@id='create-brief'] | //*[contains(@class, 'create-brief')]
${BRIEF_MODAL}                //div[contains(@class, 'modal')] | //div[contains(@role, 'dialog')] | //div[contains(@class, 'dialog')]
${CAMPAIGN_NAME_INPUT}        //input[@name='campaign_name'] | //input[@name='campaignName'] | //input[@id='campaign_name'] | //input[@id='campaignName'] | //input[contains(@placeholder, 'Campaign Name')] | //input[contains(@placeholder, 'ชื่อแคมเปญ')]
${PRODUCT_NAME_INPUT}         //input[@name='product_name'] | //input[@name='productName'] | //input[@id='product_name'] | //input[@id='productName'] | //input[contains(@placeholder, 'Product Name')] | //input[contains(@placeholder, 'ชื่อผลิตภัณฑ์')]
${CATEGORY_DROPDOWN}          //button[@data-slot='trigger'][@aria-haspopup='listbox'] | //button[@data-slot='trigger'][contains(., 'หมวดหมู่สินค้า')] | //button[@type='button'][@aria-haspopup='listbox'] | //button[contains(., 'หมวดหมู่สินค้า')] | //button[contains(@aria-label, 'category')] | //button[contains(@aria-labelledby, 'category')] | //*[@id='category'] | //*[contains(@class, 'category')]//button | //div[contains(@class, 'category')]//button | //select[@name='category'] | //select[@id='category']
${CATEGORY_LISTBOX}           //div[@role='listbox'] | //ul[@role='listbox']
${CATEGORY_OPTION}            //li[@role='option'] | //li[contains(@data-key, 'category')]
${DESCRIPTION_INPUT}           //textarea[@name='productInfo'] | //textarea[contains(@placeholder, 'รายละเอียดเบื้องต้นและเงื่อนไข')] | //textarea[@name='description'] | //textarea[@id='description'] | //textarea[contains(@placeholder, 'Description')] | //textarea[contains(@placeholder, 'รายละเอียด')] | //textarea[@data-slot='input'] | //input[@name='description'] | //input[@id='description']
${DRAFT_BUTTON}               //button[contains(text(), 'Draft')] | //button[contains(text(), 'บันทึกแบบร่าง')] | //button[@type='button'][contains(text(), 'Draft')]
${SAVE_BUTTON}                //button[contains(text(), 'Save')] | //button[contains(text(), 'บันทึก')] | //button[@type='submit'][contains(text(), 'Save')] | //button[contains(text(), 'Submit')]
${BRIEF_SUCCESS_MESSAGE}      //div[contains(text(), 'success')] | //div[contains(text(), 'สำเร็จ')] | //div[contains(text(), 'created')] | //div[contains(text(), 'สร้างแล้ว')]
