﻿test/ (старая версия проекта с hibernate)

IDE: IntellJ IDEA
База данных: oracle database 11g
Сервер: tomcat

### Виталий
Добавил новую сущность "Событие".

### Анатолий. 
Добавлена сущность "Сообщение" 

### Виталий. 
Сделал вход на сайт. Вход осуществляется по почте и паролю. 
Нельзя зарегистрироваться, если такая почта уже есть. 
Проверка вводимых данных, например, корректность имени или города.
Пока правда об этом никак пользователю не сообщается (просто отказ в регистрации).
Отказ во входе, если данные введены неправильно.
Хранение текущей сессии(httpsession). Теперь не нужно вводить id отправителя письма 
или кто создает событие. 
Нельзя без входа на сайт отправить письмо или создать событие.

### Виталий. 
Сделал страницу с профилем, где отображается информация о пользователе.
Также добавил возможность изменять профиль. Немного мелких правок. 

eav/ (текущая версия)

IDE: IntellJ IDEA
База данных: oracle database 11g
Сервер: tomcat

### Виталий
Сделал реализацию класса с JDBC для нашей EAV модели.
Пока реализовал простые select-ы и удаление (буду дополнять)
Протестировал работу методов в веб-приложении.
В классе представлены два способа соединения с БД: через DriverManager и с помощью JNDI.
Немного изменил структуру БД (разбил ФИО на разные атрибуты)

### Виталий
Добавил регистрацию пользователя в eav модели(пока корявенько).
Исправил баги с удалением.
Еще немного поменял БД.

### Виталий
Немного правок.
Добавил метод на получение конкретного поля из параметров.
Перенес свой старые стили, чтобы не смотреть на скучный белый экзан.

### Виталий, Анатолий.
Разобрались с работой Spring Security. Сделали с помощью него логин на сайт.
Опробовали работу с ролями. Сделали запоминание пользователя в cookie.
Подкючено хэширование паролей(bcrypt) как при добавлении пользователя в БД, так и проверки пароля во время логина.
Изменена структура проекта, убрано много лишнего.
Добавлена новая главная страница для авторизированного пользователя и обычного гостя. 
Много других мелких правок.
ВНИМАНИЕ! Для успешной работы проверяйте логин и пароль для подключения к БД(файл context.xml и oracle-datasource.xml)
ВНИМАНИЕ! Для проверки добавляйте новых пользователей. Пользователя у которых в базе не хэшированные пароли не смогут войти.

### Виталий
Добавил страницу с профилем текущего пользователя. Изменять профиль пока нельзя, поэтому не нажимайте "Сохранить". 
Пароль можно будет изменить и восстановить на отдельной странице, которая надеюсь когда-нибудь появится.

### Виталий
Добавил изменение профиля текущего пользователя.
Не могу понять как мне устанавливать активным элемент radio в зависимости от значения в БД.   

### Анатолий
Реализовано добавление событий - страница jsp с формой создания, переход с главной страницы авторизованного пользователя.

### Анатолий
Реализована полноценная работа с событиями: создание, редактирование, удаление, вывод списка событий для текущего пользователя. Настроена безопасность в Spring Security для реализованного функционала событий.

### Константин
Страница пользователя (user.jsp) со скудным функционалом. Хватает из базы данные о пользователе,  так же частично реализовано добавление событий из БД на таймлайн(при учёте что событие только одно). Так же рекомендую(обязую) хранить данные в следующем виде:
Приоритет задачи: строка Style1/Style2/ Style3 - где 1 - самый высокий приоритет.
Даты: строка формата dd.MM.yyyy hh:mm (02.12.2017 23:08 например).
Поменял на страницах addEvent, editEvent тип вводимых данных - с дат на строки(для полей, где нужно указать дату). Теперь с этих страниц вроде нормально добавляется в базу (хотя отображает всё по старому).

### Виталий
Добавил поиск пользователей

### Анатолий
Реализовано добавление пользователей в список друзей

### Виталий, Анатолий
Добавили отправку сообщений другому пользовалю. Прикрепили темплейты в виде верхнего меню. 

### Константин
Страницы: список друзей(потом по их аналогии можно сделать список встреч, уведомления) , встреча. 
Пока что всё на HTML, т.к. в базе пока что нет нужных данных. На странице встреч много кнопок слева - просто сделал заранее все, а там они будут выводиться в зависимости от того, кто зашёл на страницу
Нужно добавить в БД следующие сущности:
Meeting(встреча) с полями: 
	название,  
	дата начала, 
	дата окончания, 
	описание, 
	организатор(пользователь, который создал встречу), 
	теги(были же идеи с поиском по тегам),
	участники.
Запрос(заявка, как угодно) с полями:
	отправитель,
	получатель,
	тип (заявка в друзья, приглашение на встречу).
Запрос нужен будет для добавления пользователей в друзья и приглашения в группу. Например пользователь А добавил пользователя Б в друзья. 
В БД создаётся запрос, где отправитель -пользователь А, получатель - пользователь Б. Пользователь Б будет видеть на своей странице уведомлений
(которую тоже нужно сделать), что ему пришла заявка в друзья. Если он принимает её - заявка удаляется, а пользователям записывается, что они теперь друзья(вроде у пользователя есть поле друзья?)
Если заявку отклоняет - то она просто уничтожается. Аналогично с добавлением на встречи, разве что отправитель/получатель будет сущность Meeting.

### Анатолий
Обновлены liguibase-скрипты для текущей стадии проекта (добавлен отдельный скрипт для добавления в базу сущности Event и тестовых данных). Можно накатить изменения на предыдущие версии, или, если "что-то пошло не так", последовательно применить все три скрипта (сначала удаление, потом создание и добавление Event). После этого все должно заработать.
Доработаны страныцы jsp с выводом списков: страница истории сообщений (оформлена в виде чата), страница вывода пользователей, страница списка событий.
Добавлена страница Встречи (meeting), пока еще не весь функционал перенесен на визуальные решения Кости
Проведены мелкие правки UI (хедер, кнопки и пр.)

### Виталий
Решена проблема с хедером (спасибо Косте). Добавил возможность просмотра расписания другого пользователя. Решил совместить его профиль с расписанием, чтобы не создавать
нагромождение полупустых страниц. Обновил базу данных: добавил атрибуты для встреч.

### Анатолий
Исправлено добавление в базу к списку друзей, реализовано удаление и вывод списка друзей, подключено к Костиному варианту оформления в виде карточек друзей (плюс сделал вариант вывода списком, allFriends_old_List.jsp)
Собрал все в крайний вариант с рабочим хедером, подключил кнопки

(Простите, там немного глючил гитхаб, пришлось немного постестить с коммитами и ревертами, на функциональности это не отразится)

### Константин
Работа с встречами в dbHelper. Создание, изменение встречи, добавление/удаление пользователей, получение списка всех встреч/списка встреч конкретного пользователя
UPD Страницы со списком встреч пользователя, а так же просмотр конкретной встречи (пока подгружается информация о встрече, расписания пока нету)
UPD2 Отображение расписания участников встречи на странице непосредственно встречи

### Анатолий
Добавлен футер на страницы jsp

### Виталий
Добавил уровень веб-сервисов. На функционале это никак не отразилось, зато проект теперь имеет более правильную структуру. + мелкие правки в коде.

### Анатолий
Добавлено левое выплывающее вертикальное меню, вроде на все страницы jsp прицепил, все теперь как надо. Но пока ссылки в меню на кнопках не установлены на ресурсы, это потом, когда установится окончательная структура оформления

### Константин
Возможность создания встречи (пока без добавления расписания/участников встречи). Небольшие правки, вроде поля users в классе Meetings. 
Из пожеланий: возможность создавать запись о событии в БД, передав в метод для создания объект типа Event (а не лист с кодами полей, и записями в них). К классу User прикрутить поля Friends, Messages.
Выпилил боковое меню на некоторых страницах, т.к. оно растягивает элементы на странице (да и вообще, смысла в его существовании не особо много, оно просто дублирует функционал хедера, и к тому же, перекрывает своим появлением доступ к элементам страницы). Так же нужно переделать немного футер - его цвет отличается от цвета заголовка, плюс нужно добавить верхний отступ (в единицах rem, например), чтобы расписание на странице не упиралось в футер.
НУ и желательно обновить скрипты - добавить всё создание в один скрипт и изменить начальные данные, т.к. большинство часть задана неверно
UPD Можно добавлять пользователей на встречи.

### Виталий
Учел часть пожеланий Кости. Теперь при работе с событиями будем вытаскивать не каждый параметр по отдельности, а целый объект благодаря @ModelAttribute. Соответсвенно теперь в хелпер будем кидать его, а не мапу с атрибутами.
Чуть позже сделаю так на остальные сущности. В класс юзер добавил лист для сообщений. Убрал левое меню со всех jsp из-за ненадобности. Исправил неправильное подключение к БД в некоторых методах. 

### Анатолий
Пофиксены ссылки на пользователей в событиях, теперь при клике в области задачи по имени пользователя происходит переход на профиль пользователя, при клике на имени организатора - на его профиль.
Есть баг с выбором приглашенных , когда никого не выбрано и жмем кнопку добавить, выоетает ошибка, надо это отлавливать.
Теги должны быть кликабельными и запускать поиск по тегу и вывод в список.
Пофиксены стили футера и главной страницы (неавторизованного юзера)

### Константин
Чутка переделал ссылки: теперь страна пользователя открывается по ссылке виде /user{userID} (как и любая встреча). Было бы неплохо еще вместо редиректа на main-login сделать редирект на /user{userID}, но я побоялся чужой код менять

### Виталий
Изменил sql запрос в методе getUsersAtMeeting, убрав distinct (из-за него у меня выдает ошибку синтаксиса, хотя у остальных все нормально). Добавил проверку при регистрации,
теперь нельзя зарегистрироваться, если такой email уже существует. Подключил свой exception - CustomException. В дальнейшем нужно будет добавить дополнительные проверки (на имя, на длину пароля и т.д.).
Убрал с main-login ненужные кнопки (а то можно было удалить самого себя из списка друзей или начать чат с самим собой).

### Виталий. Анатолий
Да здравствует DataObject! Мы избавляемся полностью от сущностей и начинаем оперировать только DO. В файлах я закину схему взаимодействия, которую сделал Женя. Учтите, что между DBHelp и загрузочным классом есть прослойка - сервисы. 
Предстоит большая нудная работа - переделать весь функционал под новую структуру. Для этого мы с Толиком написали два рабочих примера, реализующие загрузку и выгрузку DO. Это регистрация и просмотр профиля текущего юзера.
Внимательно посмотрите, как они работают и постепенно переделывайте таким образом все остальные методы. Сущности пока не советую удалять, иначе все упадает, сделаем это в конце. Еще я переделал проверку на повторяющийся email, но
мою прошлую ошибку все равно никто не заметил) 

### Константин
Добавил в скрипт создания meeting записи в таблицу Obj_Attributes. Посмотрел на DataObject и юзер контроллер, думаю стоит тянуть данные о полях объекта из таблицы Obj_Attributes, ато она у нас простаивает.

### Виталий
Перевел на DO добавление события (через старый вариант и через таймлайны), отображения информации о пользователе и загрузка его событий на странице main-login. Объедини создание бд в одном файле 01, 
заметил в Obj_Attributes Object_Type_ID в встрече на 1004. Имеются ряд проблем. Например, если событий на таймлайне больше одного и начать их туда-сюда двигать, то пропадает дополнительная инфа или,
что еще веселее, одна инфа может замениться другой. Не знаю с чем это связано. Там же есть технические косяки в коде, например, в методе getDataObjectById и getListDataObjectById, если с первым все
более-менее нормально, то во втором случае мы не знаем id у объектов, которые хотим получить. Поэтому я бросаю туда строку и проверяю, чему она соответствует. В дальнешем мы перейдем на фильтры, чтобы
искать только ту информацию, которая нам нужны. Фильтры будут подставляться в SQL код и формировать запрос. Но пока так. Вообще я предлаю все проблемы, пожелания и недостатки писать где-нибудь, чтобы
остальные могли их видеть. Например, в том же trello, так мы будем сразу видеть, где у нас проблемы. 

### Анатолий
Обновил DataObject, значения ссылок REFERENCES теперь хранятся в списке, так как ссылок может быть много, плюс добавлены соответствующие методы.
Добавил альтернативные методы даталоадера и соотвественно альтернативные методы DBHelp. Теперь в DBHelp есть универсальный запрос в БД, который позволяет вытащить все параметры и ссылки датаобджекта по его айди, а также универсальный запрос и метод, позволяющий за один запрос вытащить список всех датаобждектов с заданнными айди.
Добавил некоторые фильтры для выбора из БД конкретных датаобджектов. Теперь все это работает в два этапа: сначала даем список фильтров для формирования уточнающего запроса, в DBHelp этот запрос формируется, исполняется и возвращает список id тех датаобджектов, которые удовлетворяют фильтрам. Затем берем полученный список айди и получаем через универсальный запрос список удовлетворяющих датаобджектов.
Большое спасибо Виталию и Косте за помошь, все получилось благодаря вашей помощь.
Теперь мне надо будет сделать альтернативное удаление аналогичным подходом и апдейт, когда это все будет готово и обкатано, можно будет полностью перейти на этот способ.
Еще надо продумать фильтры, пока у меня там через ифы-элсы собирается конструкция запроса, и пока только сделал фильтры на тип датаобджектов.
Поправил нерабочие ссылки и вызов метода в контроллере, отвечающие за вывод информации о профиле интересующего юзера. Теперь профиль нормально отображается.
Перенес загрузку картинок-аватаров на удаленный фтп из-за сложностей с обновлением картинок при работающем томкете. Теперь по кнопке Загрузить картинку каждая новая картинка забирается и переносится на фтп, в отдельню папк с именем, совпадающим с id пользователя, а полная ссылка на html-ресурс (картинку) заносится в базу. Потом этот атрибут подставляетеся на jsp и все нормально работает.


### Виталий
Перевел поиск, список всех событий и отображение информации с расписанием о другом пользователей на DO (пока без фильтров). Исправил проблему с отображением событий + убрал лишние кнопки. 
На данный момент имеется проблема с отображением имен пользователей на странице allUser (если их больше трех). Толик обещал разобраться. 

### Анатолий
Как обещал, исправил баг с дублированием строк в датаобджектах при загрузке из базы через альтернативный лоадер.

### Анатолий
Сделал новые фильтры для DO, новые методы для loadingService. Пока они подключены в качестве альтернативных, могут работать вместе со старыми. Но надо как-то от старых уже переходить на новые.
Сделал в DBHelp универсальный парсер-генератор SQL запросов, который получает фильтры, их парсит и составляет необходимый для уточнения id датаобджектов запрос в виде строки. Добавил исполняющий метод, куда эта строка отправляется, делается запрс в базу и возвращается список id's подходящих под примененные фильтры датаобджектов.
Затем этот список айдишек можно уже отдать в универсальный метод получения списка датаобджектов по списку айди.
Фильтры составные, основная часть и уточняющая часть, например, основная - все сообщения между пользователями с именами (и вводим имена), уточняющая - временной промежуток С и ДО, или только РАНЬШЕ или только ПОЗЖЕ, еще надо добавить в базу атрибут СТАТУС ПРОЧТЕНИЯ, тогда заработает еще один фильтр по прочтению. Аналогичные фильтры сделал на все сущности, но надо проверить еще полностью каждый фильтр отдельно.
Надеюсь, скоро перейдем на такой подход, а то совсем запутываюсь в старом и новом.

### Виталий
Перевел методы класса UserController на новые фильтры Анатолия. Работает все как часы. Сущность юзера пока не удаляю, может пригодится еще. Предлагаю пока не делать универсальные методы для создания и удаление DataObject. Так мы только уберем некоторые методы, а в производительности вряд ли выиграем. Если что, то сделаем это потом. На выходных добью все остальные методы для других классов. Единственное, что
вызывает вопросы - встречи. Скорей всего в мапе с ссылками нам придется хранить ссылки на другие объекты DO (в частности на участников и на события). Обновил базу. Вместо страны теперь у нас будет город, что более логично. Не стал добавлять его как новое поле, так как пришлось бы обновлять многие jsp.

### Анатолий
Добавил 2 новых метода для работы с датаобджектами (выгрузка в базу и обновление), теперь можно использовать их как универсальные для работы с любыми сущностями. Пока прикрутил метод обновления на профиль, а метод выгрузки - на создание профиля.

### Виталий
Прикрутил на контроллеры в UserController, EventController и KKUserController новые методы для работы с DO, которые добавил ранее Толик. Теперь эти три класса работают на универсальных методах (кроме метода setDataObjectToDB - с ним некоторые проблемы, появится позже). Удалил некоторые ненужные методы и сделал мелкие исправления в других классах. Чуть позже проведу тотальную чистку, а то много лишнего скопилось.
Ну и самом главное, у нас появился кэш, который будет хранить наши объекты, что повысит скорость работы всего приложения, ведь теперь не нужно лезть каждый раз за объектами в БД, при перезагрузке страницы. Размер и время хранения вы можете регулировать сами, как вам удобно. Пока кэш работает лишь на странице main-login. В консоль я вывожу всю инфу о его работе, если она вам нужна будет. Обращаю внимание, что объекты не только заносятся в кэш, но и обновляются без лишних действий вроде выгрузки и повторного внесения. Остальные правки минимальные и внимания не стоят. 

### Анатолий
Добавил чатичные фильтры на загрузку отдельных кусков датаобджектов и метод для загрузки частичных DO в класс DBHelp по списку переданных айди.
Теперь фильтры работают в два этапа: сначала фильтруем обычными фильтрами, которые позволяют определиться с различными условиями, получаем айди-список этих объектов, затем айди-список соединяем с частичными фильтрами, где задаем, что конкретно в датаобджекты подгружать из базы. Надо теперь подключить все к кэшу.
Все частичные фальтры в пакете partitions_filters.

### Анатолий
Добавил методы вызова частичных фильтров в лоадинг сервис.

### Виталий
Соединил все метолы в UserController с кэшом. Толик соединил с кэшом методы EventController. Мы тут подумали и решили пока не использовать новые фильтры из-за нецелесообразности и сложности работы их вместе с кэшом. 

### Константин
Добавил конструкторы, принимающие в качестве параметра DataObject, в следующие классы: Meeting, User, Event. Страница встречи, а так же просмотра пользователя (которая по ссылке "user{id}") грузят данные через DataObject.

### Анатолий
Поправил метод выгрузки датаобджекта в базу setDataObjectToDB, переделал методы добавления и удаления из друзей (в DBHelp) на работу через DO-обновление, в класс DO добавил метод удаления ссылок из мапы ссылок.

### Виталий
Наконец-то мы поправили setDataObjectToDB, надеюсь больше с ним проблем не будет. Вернул работу с сущностями на jsp в UserController, теперь получать параметры стало проще. Исправил немного конструкторы User и Event.

### Константин
В Event и Meeting добавил методы toDataObject (не знаю, есть ли в подобных методах особая нужда, но мне так проще). Создание встречи происходит теперь через DataObject

### Виталий
Вернул сущности в EventController и KKUserController. Присоединил код Дениса, переведя работу с сообщениями на DO (для сообщений пока не было конвертирующего механизма в сущность). Также подключил туда свой кэш. Метод отправки пока работает по старому (из-за ошибки типов, будет исправлено чуть позже). 

### Анатолий
По совету Кости собрал все нужные методы для работы с DO в один region, поправил метод отправки сообщений через DO.

### Виталий
Сделал первоначальную вычистку проекта, удалил старые и не нужные методы (методы встреч пока не трогал), удалил бесполезные сервисы, переработал LoadingService в полноценный веб-сервис. 

### Анатолий
Поправил косяки в работе с аватаром. Теперь есть: при регистрации - аватар по умолчанию, отображение аватаров на юзеров на разных страницах jsp, отображение нового аватара сразу после загрузки.

### Виталий
Подключил JavaMail API. Добавил подтверждение регистрации с помощью специальной ссылки. Теперь у каждого пользователя есть поле confirmed (не забудьте обновить базу). Изначально при регистрации это поле равно false. Чтобы получить доступ к приложению, вам нужно зайти на почту, которую вы указали при регистрации
и перейти по специальной ссылке, которая должна была вам прийти в письме. После активации ссылки поле станет true и вам разрешат войти на сайт. Если вы не хотите указывать реальные адреса, то просто в ручную измените этот параметр в базе (15 атрибут). Исправил ошибку с кэшем. 

### Анатолий
Начал работу над системой оповещения о новых сообщениях, событиях и пр. Сделал вывод информации о новых сообщениях на AJAX в область хэдера. Если нет новых сообщений, отображается как "Нет новых сообщений", иначе выводит количество сообщений и ссылку на страницу просмотра (пока еще нет страницы просмотра).

### Константин
Добавил возможность редактирования информации о встрече, чутка поправил скрипты, чтобы исходные данные (2 пользователя и их события) работали корректно.

### Анатолий
Переделал отправку сообщений на AJAX. Пришлось выставить полный адрес http://localhost:8081 в настройках, иначе невозмоно было достучаться до контроллера. Так что если у кого не заработает, проверьте порт чтобы был 8081.
Для оповещений сделал обновление статуса при прочтении.
Поправил метод генерирования нового ключа id в базе для датаобджектов. В предыдущей версии соединение не закрывалось, из-за этого после определенного количества добавленных датаобджектов они переставали добавляться.
Исправил запрос в фильтрах текущего юзера.
Немного поправил фильтры на MessageFilter.BETWEEN_TWO_USERS_WITH_IDS
Сделал отдельный класс конвертер для конвертации сущностей в датаобджекты и обратно (еще не полностью). Убрал кнопку удаления с чужих сообщений. Плюс еще некоторые мелкие правки.

### Виталий
Попробовал себя в фронтенде (зря, наверное). Сделал валидацию на странице регистрации. Получилась какая-то дикая смесь из JS и HTML5. Да и смотрится так себе. Но главное, что работает) На пароль специально ограничения пока не ставил. Написал конвертер из DO в User, раз уж мы решили, что конвертер будет отдельным классом.
Нужно доделать встречи, а то часть методов работает на DO, часть на старых методах. Из-за этого не могу туда кэш подключить пока что и окончально DBHelp почистить. 

### Константин
Почти всё в митинге работает с DataObject, кроме получения списка встреч для пользователя. Вот думаю, можно завести еще одно поле для User (имею ввиду в базе данных), где придётся хранить данные о его встречах (которые будут дублировать данные о пользователях в сущности Meeting), либо нужно из базы тянуть ссылки на встречи, где встречается заданный пользователь

### Виталий
Улучшил валидацию. Теперь сообщения об ошибках не вылезают пока вы не наведете курсор на поле. Смотрится лучше. Добавил страницу с расширенными настройками, где пока только вы можете подтвердить свой номер телефона (обновите базу), своего рода рабочий прототип смс-рассылки. Нужен фронтенд на этой странице. Сразу скажу, что отправка смс платная, так что не стоит
этим часто пользоваться (аккаунт я создал свой). Для тестирования работы (если уж вам так интересно), раскомментируйте код в /generatePhoneCode и укажите свой номер и текст сообщения. Затем создайте нового пользователя, перейдите в расширенные настройки. Отправьте код и вбейте его в поле и нажмите подвердить. Вы великолепны) Проверьте базу, поле должно стать
true. Теперь можете управлять своими рассылками через смс (который нет пока) на этой странице (на которой нет этого управления). А затем закомментируйте код обратно!! С каждый нажатием кнопки съедают от 1 до 1.5 рубля. На аккаунте не много осталось, но на разок вам хватит. План такой: сделать полноценные оповещения через смс, проверить и не использовать до 
финальных тестов и показа проекта. А пока только подтверждение телефона. 

### Константин
Куча мелких правок(аж сам забыл чё сделал). Добавил к сущности Meeting поле events, где будет храниться расписание встречи(в конструктор из DataObject и в метод toDataObject тоже прописал). Но не могу догнать как записать ивент встречи в БД. Я так понял что в БД, при записи обычного ивента, в таблицу ссылок записывается юзерайди, который автоматом вытягивается, и, выходит, любой ивент, созданный в текущей сессии, будет привязан к пользователю, который работает в этой сессии, это дело нужно поправить, дать возможность прикрепить ссылку не на текущего юзера, а на встречу

### Анатолий
Различные мелкие правки. Сегодня увидел, что наш фтп для загрузки заблочили (наверное, заметили постоянную нагрузку на фтп и низкую на http), подключил новый. Я думаю потом, когда будем выводить в сеть проект, отдельно подниму фтп ля этих целей.
Поправил добавление пользовательского айди при создании события, иначе поле host_id пустовало (выделил номер 141 под ATTR_ID в REFERENCES). Сделал добавление обратной ссылки Событие - Юзер в ивентовский датаобджект. Не забудьте обновить базу!
Добавил соотвествующие изменения в частичный фильтр по ивенту, добавил отсутствующие методы в конвертер.
Начинаю делать прикрепление ссылки на встречи.

### Виталий
Подключил кэш в контроллере встреч. Переписал получение списка встреч, но оставил старый способ, так как через фильтры не получает встречи (неправильно написан запрос). Удалил некоторые старые и ненужные методы. Частично перенес стили и код js в отдельные файлы. 

### Анатолий
Добавил в генератор id проверки на выход за границы диапазонов, переписал запрос в фильтре на получение встреч как DO и подключил его в контроллере. Сделал прикрепление ссылки на событие к встрече. Теперь если с jsp на кнопку повесить localhost:8081/addEvent/{meeting_id}, то при создании события оно будет добавляться не к текущему пользователю, а к встрече, айди которой передали, а если не указывать {meeting_id}, то как раньше будет прикрепляться к текущему юзеру. На страничке не делал кнопки пока, проверьте, как будет работать.

### Анатолий
Сделал уведомления о добавлении в друзья с подтверждением для добавляемого пользователя, в NotificationController универсальный метод, правки в DBHelp, а то не удалялся юзер, добавил страницу новых сообщений, ну и там всякое по мелочи.

### Виталий
Реализовал уведомления о добавлении в друзья на email и телефон. Переписал метод для отправки email, разбив его на более мелкие части. Исправил некоторые ссылки.

### Анатолий
Сделал подключение google-календаря. Пока что есть кое-какие косяки, не весь функционал реализован, доделаю со временем. Пока можно подключить календарь, синхронизировать события с событиями в БД оракл. Для каждого юзера свой календарь цепляется автоматически, при нажатии кнопки "Подключить" на странице профиля, страничка перекидывает на страницу авторизации гугла, где надо дать доступ к календарю или зарегестрировать новый. После этого забирается идентификационный токен, парсится и сохраняется в BLOB-объект базы. Для этих целей чуть переделал базу, сделал еще одну таблицу, соединенную с OBJECTS, на общий функционл это не повлияло вроде. При каждом новом сеансе нового пользователя при синхронизации с календарем вытаскивается идентификационный файл, а если его нет, то опять используется сервис подгрузки авторизации с сайта гугл.

![База](http://www.imageup.ru/img17/2702348/2017-03-06_11-58-27.jpg)

![Страничка](http://www.imageup.ru/img17/2702350/2017-03-07_18-37-01.jpg)

![Гугл календарь после синхронизации](http://www.imageup.ru/img17/2702352/2017-03-06_17-15-30.jpg)

На самом деле прикольная штука, оень понравился календарь гугловский, перекрывает весь наш функционал с лихвой. Есть и приглашения на встречи, и уведомления на почту, и на телефон в виде смс, и всплывающие уведомления на андроид. Можно массово привязывать юзеров на втречи через api, просто уазывая их почту. 
Но пока все еще довольно корявенько сделано у меня. Пару дней просидел, а там еще куча всего делать нужно.
Еще можно встраивать на страницу юзера календари, джаваскриптом проставляя их идентификаторы, хорошая возможность.
Сделал там еще правки по мелочи, нужна помощь в сериализации гугловского идентификатора, пока все сделано через костыль.
Не забудьте обновить базу через liquibase!

### Виталий
Обновил базу данных, добавив туда объект с настройками и соединил их с пользователями. Добавил сущность в код, переписал метод добавления нового пользователя и обновил конвертер. Пока там лишь шесть полей, но по мере разрастания настроек буду обновлять их. Теперь буду писать механизм управления настройками.
### Константин
Добавил HTML страницу с центром уведомлений (notification.html). Там пока сделал 4 вида уведомлений: добавление в друзья, приглашение на встречу, заявка на встречу (Вася хочет принять участие в вашей встрече), уведомление о добавлении в друзья (Петя добавил вас в друзья). Больше не придумал, что еще может понадобиться.
UPD Добавил центр уведомлений в хэдер, пока без функционала
UPD2 Добавил сущность Notificaton, можно её сохранить в базе и получить по id.
КАК ДОЛЖНО РАБОТАТЬ
Вася добавил Петю в друзья. Создаётся объект Notification, где отправитель Вася, получатель - Петя, тип: заявка в друзья. Заявка висит и маячит перед глазами Пети, 
пока он не отклонит запрос, либо пока не добавит в друзья. В первом случае она просто уничтожится, во втором - сначала они добавятся в друзья, 
а потом уведомление уничтожится.(это я для себя, потмоу что с ума схожу каждый раз вспоминая что как куда должно быть)

### Виталий
Добавил первоначальный механизм управления расширенными настройками пользователя. Добавил конвертацию DO в сущность настроек + новый конструктор для них.  Пользователь выбирает нужные ему уведомления и сохраняет настройки. checkbox-ы выставляются в зависимости от значений в базе. Возможно не самым элегантным способом
это реализовал, но зато точно работает. Подключил туда кэш заодно. На функционале это пока не отразилось, добавлю отправку уведомлений в зависимости от настроек чуть позже.
UPD Наконец-то исправлена проблема с полом пользователя. Теперь значение выставляется из базы. Изначально у нового пользователя пол неизвестен. Подправил регистрацию, а у нас оказывается некоторые строчки в базу не заносились, а следовательно их нельзя было обновить.  

### Анатолий
Начал работу над статистиками и файлами. Работа со статистиками будет сосуществляться в две стороны: система логирования StatisticLogger будет накапливать статистику пользователя и периодически (при превышении задаваемого порога) сбрасывать статистику в базу. С другой стороны будет работать система формирования статистики StatisticManager, она будет выполнять выгрузку логов из базы и формировать по алгоритмам различные статистики, которые затем будут мапится через контроллер статистики на страницу просмотра статистик.
Сейчас сделал систему логирования в базу. Определил сущность log с id 1008, она имеет различные типы (айди типов), например, лог на посещение страницы, лог на добавление в друзья и пр. Хранит время формирования лога и ссылку на юзера. Еще для логов немного сделал по-другому формирование параметров и ссылок: практически лог может хранить либо то, либо то, например, либо ссылку на на сообщение при логировании добавления сообщения, либо текстовое поле info с текстовой информацией. То есть лог имеет либо тип + ссылка, либо тип + инфо. Это все для того, чтобы не дублировать информацию из объектов (сообщений, юзеров), действия с которыми залогировали.
Прикрутил логирование на UserController пока что, потом прикручу на остальные. Думаю, вешать логирование на контроллеры проще всего, так как все равно все действия юзера проходят через контроллеры.
Обновил liquibase, не забудьте обновить базу!

### Виталий
Заработал механизм отправки уведомлений по расширенным настройкам. Если вы хотите получать уведомления, то поставьте соответствующие галочки в настройках. Уведомления со встречами не работают, так как это еще в приложении не реализовано. В DBHelp во всех методах (вроде) стал использовать try с ресурсами, для гарантийного закрытия соединений. Подправил добавление в друзья со страницы searchUser.