<%--
  Created by IntelliJ IDEA.
  User: Lawrence
  Date: 29.01.2017
  Time: 21:49
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=utf8"
         pageEncoding="utf8" %>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Настройки</title>
    <link href="<%=request.getContextPath()%>/resources/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/bootstrap-select.min.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/css/tlmain.css">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="<%=request.getContextPath()%>/resources/js/bootstrap-select.min.js"></script>


    <%@include file='header.jsp' %>

</head>
<body>
<div class="container">
    <div class="container">
        <h2>Настройки</h2>
        <ul class="nav nav-tabs nav-justified">
            <li class="active"><a data-toggle="tab" href="#general">Основные</a></li>
            <li><a data-toggle="tab" href="#privacy">Уведомления и приватность</a></li>
            <li><a data-toggle="tab" href="#security">Безопасность</a></li>
        </ul>

        <div class="tab-content">
            <div id="general" class="tab-pane fade in active">
                <h3>Основные</h3>
                <div class="well bs-component">
                    <div class="row">
                    <div class="col col-lg-5 col-md-6">
                        <form action="/changeProfile/${user.id}" method="post">
                            <fieldset>
                            <div class="form-group  ">
                                <label for="InputName1">Введите Имя</label>
                                <input type="text" class="form-control " name="name" id="InputName1" value=${user.name}>
                            </div>

                            <div class="form-group ">
                                <label for="InputSurname1">Введите фамилию</label>
                                <input type="text" class="form-control" name="surname" id="InputSurname1"
                                       value=${user.surname}>
                            </div>

                            <div class="form-group ">
                                <label for="InputMiddleName1">Введите отчество</label>
                                <input type="text" class="form-control" name="middle_name" id="InputMiddleName1"
                                       value=${user.middleName}>
                            </div>

                            <div class="form-group  ">
                                <label for="InputAge1">Введите вашу дату рождения</label>
                                <input type="date" class="form-control" name="ageDate" id="InputAge1" value=${user.ageDate}>
                            </div>

                            <div class="form-group  ">
                                <label>Выберите ваш пол</label>
                                <div class="radio">
                                    <label>
                                        <input type="radio" name="sex" id="Gender1" value="мужской"  <c:if test="${user.sex eq 'мужской' or user.sex eq null}">checked</c:if> >
                                        Мужской
                                    </label>
                                </div>
                                <div class="radio">
                                    <label>
                                        <input type="radio" name="sex" id="Gender2" value="женский" <c:if test="${user.sex eq 'женский'}">checked</c:if> >
                                        Женский
                                    </label>
                                </div>
                            </div>

                            <div class="form-group  ">
                                <label for="InputCity1">Введите ваш город</label>
                                <input type="text" class="form-control" name="city" id="InputCity1" value=${user.city}>
                            </div>

                            <div class="form-group  ">
                                <label for="InputPhone1">Введите ваш номер телефона</label>
                                <input type="text" class="form-control" name="phone" id="InputPhone1" value=${user.phone}>
                            </div>

                            <div class="form-group ">
                                <label for="TextArea1">Расскажите немного о себе</label>
                                <textarea rows="3" class="form-control noresize" name="info"
                                          id="TextArea1">${user.additional_field}</textarea>
                            </div>

                            <button type="submit" class="btn btn-info col-lg-5 col-lg-offset-4">Сохранить</button>
                        </fieldset>
                        </form>
                    </div>
                    <div class="col col-lg-5 col-lg-offset-2 col-md-6">
                        <%--
                          <img src="http://nc2.hop.ru/upload/${user.id}/avatar/avatar_${user.id}.png"
                             onerror="this.src = 'http://nc2.hop.ru/upload/default/avatar.png'" class="img-polaroid"
                             width="200">
                        --%>
                        <img src="${user.picture}"
                             onerror="this.src = 'ftp://netcracker.ddns.net/upload/default/avatar.png'" class="img-polaroid"
                             width="200">

                        <div class="form-group ">
                            <%--Загрузка картинки-аватара--%>
                            <label for="InputImg">Загрузка изображения</label>
                            <form method="POST" action="/uploadAvatar" enctype="multipart/form-data">
                                <input type="hidden" name="MAX_FILE_SIZE" value="20971520"><%--Ограничение на максимальный размер файла = 20 Мб со стороны клиента--%>
                                Файл: <input name="file" type="file" id="InputImg"
                                             accept="image/jpeg, image/png, image/gif"> <%--Ограничение на тип файла со стороны клиента--%>
                                <input type="submit" value="Загрузить"> Загрузить
                            </form>
                        </div>
                        <img src="https://lifehacker.ru/wp-content/uploads/2014/11/01_Comp-2.png" class="img-polaroid"
                             width="200">
                        <div class="form-group ">
                            <%--Кнопка подключения календаря--%>
                            <label for="InputImg">Подключите Google-календарь</label>
                            <div class="form-group ">
                                <a href="/addCalendar">
                                    <button type="button" class="btn btn-info"><span class="glyphicon glyphicon-calendar"
                                                                                     aria-hidden="true"> Подключить</span>
                                    </button>
                                </a>
                                <a href="/synchronizeCalendar">
                                    <button type="button" class="btn btn-info"><span class="glyphicon glyphicon-calendar"
                                                                                     aria-hidden="true"> Синхронизировать</span>
                                    </button>
                                </a>
                            </div>
                        </div>
                        <div class="form-group ">
                            <a href="#myModal" data-toggle="modal"> Изменить пароль </a>
                        </div>
                        <div class="modal fade" id="myModal">
                            <div class="modal-dialog">
                                <!--  <div class="modal-content"> -->
                                <div class=".col-xs-6 .col-md-4">
                                    <div class="panel panel-default">
                                        <div class="panel-body">
                                            <div class="text-center">
                                                <h3><i class="fa fa-lock fa-4x"></i></h3>
                                                <h2 class="text-center">Хотите изменить пароль?</h2>
                                                <p>Вы можете изменить ваш пароль здесь.</p>
                                                <div class="panel-body">
                                                    <form method="post" id="passwordForm" action="/changePassword">
                                                        <input type="password" class="input-lg form-control" name="password1" id="password1" placeholder="New Password" autocomplete="off">
                                                        <div class="row">
                                                            <div class="col-sm-6">
                                                                <span id="8char" class="glyphicon glyphicon-remove" style="color:#FF0004;"></span> Не менее 8 символов<br>
                                                                <span id="ucase" class="glyphicon glyphicon-remove" style="color:#FF0004;"></span> Одна заглавная буква
                                                            </div>
                                                            <div class="col-sm-6">
                                                                <span id="lcase" class="glyphicon glyphicon-remove" style="color:#FF0004;"></span> Одна строчная буква<br>
                                                                <span id="num" class="glyphicon glyphicon-remove" style="color:#FF0004;"></span> Одна цифра
                                                            </div>
                                                        </div>
                                                        <input type="password" class="input-lg form-control" name="password2" id="password2" placeholder="Repeat Password" autocomplete="off">
                                                        <div class="row">
                                                            <div class="col-sm-12">
                                                                <span id="pwmatch" class="glyphicon glyphicon-remove" style="color:#FF0004;"></span> Пароли совпадают
                                                            </div>
                                                        </div>
                                                        <input type="submit" class="col-xs-12 btn btn-primary btn-load btn-lg" data-loading-text="Changing Password..." value="Change Password">
                                                    </form>

                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="form-group ">
                            <a href="/advancedSettings"> Расширенные настройки </a>
                        </div>
                    </div>
                </div>
                </div>
            </div>
            <div id="privacy" class="tab-pane fade">
                <h3>Уведомления и приватность</h3>
                <div class="well bs-component">
                    <div class="row">
                        <div class="col col-xs-12 col-sm-10 col-sm-offset-1 col-md-8 col-md-offset-2 col-lg-6 col-lg-offset-3">
                            <form action="/updateSettings/${settings.id}" method="post">
                                <fieldset>
                                    <!--  Тут будут настройки оповещения для email и телефона с кнопкой Сохранить. Нужен фронтенд. -->
                                    <div class="row">
                                        <div class="col col-xs-12 col-sm-8 col-sm-offset-2 col-md-8 col-md-offset-2 col-lg-8 col-lg-offset-2">
                                            <div class="form-group">
                                                <div class="text-center">
                                                    <label class="control-label" for="privateProfile">Кто может просматривать мой профиль</label>
                                                    <select id="privateProfile" name="privateProfile" class="selectpicker show-menu-arrow" data-style="btn-info">
                                                        <option <c:if test="${settings.privateProfile eq 'any'}">selected</c:if>  value="any">Все</option>
                                                        <option <c:if test="${settings.privateProfile eq 'onlyFriend'}">selected</c:if> value="onlyFriend">Только друзья</option>
                                                        <option <c:if test="${settings.privateProfile eq 'nobody'}">selected</c:if> value="nobody">Никто</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="text-center">
                                                    <label class="control-label" for="privateMessage">Кто может писать мне личные сообщения</label>
                                                    <select id="privateMessage" name="privateMessage" class="selectpicker show-menu-arrow" data-style="btn-info">
                                                        <option <c:if test="${settings.privateMessage eq 'any'}">selected</c:if>  value="any">Все</option>
                                                        <option <c:if test="${settings.privateMessage  eq 'onlyFriend'}">selected</c:if> value="onlyFriend">Только друзья</option>
                                                        <option <c:if test="${settings.privateMessage  eq 'nobody'}">selected</c:if> value="nobody">Никто</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <ul class="list-group">
                                            <li class="list-group-item">
                                                Отправлять уведомления о новых сообщениях на почту
                                                <div class="material-switch pull-right">
                                                    <input id="i1" type="checkbox" name="emailNewMessage"  <c:if test="${settings.emailNewMessage eq true}">checked=checked</c:if> >
                                                    <label for="i1" class="label-success"></label>
                                                </div>
                                            </li>
                                            <li class="list-group-item">
                                                Отправлять уведомления о новых заявках в друзья на почту
                                                <div class="material-switch pull-right">
                                                    <input id="i2" type="checkbox" name="emailNewFriend"  <c:if test="${settings.emailNewFriend eq true}">checked=checked</c:if> >
                                                    <label for="i2" class="label-success"></label>
                                                </div>
                                            </li>
                                            <li class="list-group-item">
                                                Отправлять уведомления о приглашениях на встречу на почту
                                                <div class="material-switch pull-right">
                                                    <input id="i3" type="checkbox" name="emailMeetingInvite" <c:if test="${settings.emailMeetingInvite eq true}">checked=checked</c:if> >
                                                    <label for="i3" class="label-success"></label>
                                                </div>
                                            </li>
                                            <li class="list-group-item">
                                                Отправлять уведомления о новых сообщениях на телефон
                                                <div class="material-switch pull-right">
                                                    <input id="i4" type="checkbox" name="phoneNewMessage"  <c:if test="${settings.phoneNewMessage eq true}">checked=checked</c:if> >
                                                    <label for="i4" class="label-success"></label>
                                                </div>
                                            </li>
                                            <li class="list-group-item">
                                                Отправлять уведомления о новых заявках в друзья на телефон
                                                <div class="material-switch pull-right">
                                                    <input id="i5" type="checkbox" name="phoneNewFriend"  <c:if test="${settings.phoneNewFriend eq true}">checked=checked</c:if> >
                                                    <label for="i5" class="label-success"></label>
                                                </div>
                                            </li>
                                            <li class="list-group-item">
                                                Отправлять уведомления о приглашениях на встречу на телефон
                                                <div class="material-switch pull-right">
                                                    <input id="i6" type="checkbox"  name="phoneMeetingInvite"  <c:if test="${settings.phoneMeetingInvite eq true}">checked=checked</c:if> >
                                                    <label for="i6" class="label-success"></label>
                                                </div>
                                            </li>
                                        </ul>
                                    </div>
                                    <div class="text-center">
                                        <button type="submit" class="btn btn-success">Сохранить</button>
                                    </div>
                                </fieldset>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <div id="security" class="tab-pane fade">
                <h3>Безопасность</h3>
                <div class="well bs-component">
                    <p>Смена пароля, подтверждение телефона и т.д.</p>
                </div>
            </div>
        </div>
    </div>

</div>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/profile.js"></script>

<div style="margin-bottom: 8rem;"/>
<%@include file='footer.jsp'%>

</body>
</html>

