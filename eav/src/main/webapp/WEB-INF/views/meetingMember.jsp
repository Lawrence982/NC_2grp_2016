<%--
  Created by IntelliJ IDEA.
  User: Костя
  Date: 10.02.2017
  Time: 2:27
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=utf8"
         pageEncoding="utf8" %>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<html lang="en">
<head>
    <%@include file='header.jsp'%>
    <title>${meeting.title}</title>

    <link rel="stylesheet" type="text/css" href="/resources/css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="/resources/css/bootstrap-select.min.css">
    <link rel="stylesheet" type="text/css" href="/resources/css/bootstrap-datetimepicker.min.css">
    <link rel="stylesheet" type="text/css" href="/resources/css/tipped.css">
    <link rel="stylesheet" type="text/css" href="/resources/css/vis.min.css">
    <link rel="stylesheet" type="text/css" href="/resources/css/tlmain.css">
    <link rel="stylesheet" type="text/css" href="/resources/css/jquery.mCustomScrollbar.min.css">

    <script type="text/javascript" src="/resources/js/jquery-1.9.1.min.js"> </script>
    <script type="text/javascript" src="/resources/js/moment-with-locales.min.js"> </script>
    <script type="text/javascript" src="/resources/js/tipped.js"> </script>
    <script type="text/javascript" src="/resources/js/vis.js"> </script>
    <script type="text/javascript" src="/resources/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="/resources/js/bootstrap-datetimepicker.min.js"></script>
    <script type="text/javascript" src="/resources/js/bootstrap-select.min.js"> </script>
    <script type="text/javascript" src="/resources/js/jquery.mCustomScrollbar.concat.min.js"> </script>

    <!-- 2017-05-12 Для работы чата (остальное в файле chat.js) -->
    <script type="text/javascript" src="/resources/js/chat.js"> </script>
    <script type="text/javascript">
        // Для работы чата (остальное в файле chat.js)
        var v_message_id = 0;
        var v_meeting_id = '${meeting.id}';
    </script>



    <style type="text/css">
        p{
            margin: 0px;
        }
        .hideinput{
            margin-bottom: 0.5rem;
        }
        .input-group-addon-my{
            min-width: 9rem;
        }
    </style>


    <script>
        var m_id = ${meeting.id};
        var str = "";

        <c:forEach items="${ids}" var="users_id">
        str = str + ${users_id} + ", ";
        </c:forEach>

    </script>


    <script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/slots.js"></script>


</head>
<body>
<div class="container top-buffer-20">

    <!-- Информация о встрече -->
    <div class="row">
        <div class="col-xs-12 col-sm-12 col-md-6 col-lg-3">
            <div class="card">
                <h3 class="card-title text-center">${meeting.title}</h3>
                <div class="profile-userbuttons">
                    <c:if test="${meeting.status eq 'active'}">
                        <a href="/leaveMeeting${meeting.id}" <c:if test="${meeting.memberUsers.size() eq 1}"> class="disabled" </c:if> >
                            <button type="button" class="btn btn-danger btn-sm" <c:if test="${meeting.memberUsers.size() eq 1}"> disabled </c:if>  >
                                <span class="glyphicon glyphicon-trash" aria-hidden="true" > Покинуть</span>
                            </button>
                        </a>
                    </c:if>
                    <c:if test="${meeting.status eq 'closed'}">
                        <a href="/deleteMeeting${meeting.id}"><button type="button" class="btn btn-danger btn-sm"><span class="glyphicon glyphicon-trash" aria-hidden="true"> Удалить</span></button></a>
                    </c:if>
                </div>
                <ul class="list-group list-group-my list-group-flush">
                    <li class="list-group-item">Организатор: <a href='/user${meeting.organizer.id}'>${meeting.organizer.name} ${meeting.organizer.middleName} ${meeting.organizer.surname}</a></li>
                    <li class="list-group-item">Начало: ${meeting.date_start}</li>
                    <li class="list-group-item">Окончание: ${meeting.date_end}</li>
                    <li class="list-group-item">Описание: ${meeting.info}</li>
                    <li class="list-group-item" name="tags">Теги: ${meeting.tag}</li>
                </ul>
            </div>
        </div>
        <!-- ЧАТ -->
        <div class="col-xs-12 col-sm-12 col-md-6 col-lg-4 col-lg-offset-5">
            <div class="card" style="background-color: rgb(236, 240, 241);">
                <div class="card-title">
                    <h3 class="text-center" id="cardsholder">Чат</h3>
                </div>
                <ul class="list-group list-group-my list-group-flush text-left chat mCustomScrollbar"
                    data-mcs-theme="minimal-dark" id="cardsholderItems" style="background-color: rgb(238, 238, 238);">

                    <div id = "insert_place_messages"></div> <!-- 2017-05-12 Место вставки сообщений, см. chat.js -->

                </ul>

                <form id="messageSend" name="creation" method="post" style="margin-bottom: 0px;"> <!-- 2017-05-12 Кнопка отправки сообщений, см. chat.js -->
                    <div class="input-group">
                        <textarea class="form-control custom-control" rows="2" style="resize:none"
                                  placeholder="Введите сообщение" maxlength="70" id="messageInput">
                        </textarea>

                        <span class="input-group-addon btn btn-primary" id="messageSendButton" title="Отправить">
							<span class="glyphicon glyphicon-send"></span>
						</span>
                    </div>
                </form>


                <div class="input-group">
					<span class="input-group-addon ">
						<div class="text-right" id="textarea_feedback">
						Осталось
						</div>
					</span>
                </div>
            </div>
        </div>
    </div>
    <!-- Timeline и кнопки -->
    <div class="row">
        <div class="col-md-12">
            <h4>Участники встречи</h4>
            <div class="btn-group btn-group-justified" role="group" aria-label="...">
                <div class="btn-group" role="group">
                    <button type="button" class="btn btn-default timeline-menu-button" id="showTodayButton">Cегодня
                    </button>
                </div>
                <div class="btn-group" role="group">
                    <button type="button" class="btn btn-default timeline-menu-button" id="showWeekButton">Неделя
                    </button>
                </div>
                <div class="btn-group" role="group">
                    <button type="button" class="btn btn-default timeline-menu-button" id="showMonthButton">Месяц
                    </button>
                </div>
                <div class="btn-group" role="group">
                    <button type="button" class="btn btn-default timeline-menu-button" id="showYearButton">Год</button>
                </div>
                <div class="btn-group" role="group">
                    <button type="button" class="btn btn-default timeline-menu-button" id="showMeetingButton">Встреча</button>
                </div>
            </div>
            <div id="visualization"></div>
        </div>
    </div>
    <!-- Форма для создания новой задачи -->
    <div id="taskmodal" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content">
                <!-- Заголовок модального окна -->
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title text-center">Создание новой задачи</h4>
                </div>
                <!-- Основное содержимое модального окна -->
                <div class="modal-body">
                    <div class='row '>
                        <div class='col-md-6'>
                            <div class="input-group">
                                <span class="input-group-addon">Название</span>
                                <input type="text" class="form-control" id="taskName"
                                       placeholder="Введите название задачи">
                            </div>
                        </div>
                        <div class='col-md-6'>
                            <div class="input-group">
                                <div type="text" class="hidden" name="eventId" id="eventId" value="mras"></div>
                                <span class="input-group-addon">Приоритет</span>
                                <select id="taskPriority" class="selectpicker form-control" title="Выберите приоритет">
                                    <option style="background: #d9534f; color: #fff;" value="Style1">Высокий</option>
                                    <option style="background: #f0ad4e; color: #fff;" value="Style2">Средний</option>
                                    <option style="background: #5bc0de; color: #fff;" value="Style3" selected>Низкий
                                    </option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <!-- DateTime Pickers -->
                    <div class='row top-buffer-2'>
                        <div class='col-md-6'>
                            <div class='input-group date' id='datetimepicker1'>
                                <span class="input-group-addon">Начало</span>
                                <input type='text' class="form-control" id="taskStartTime"/>
                                <span class="input-group-addon">
							<span class="glyphicon glyphicon-calendar"></span>
						</span>
                            </div>
                        </div>
                        <div class='col-md-6'>
                            <div class='input-group date' id='datetimepicker2'>
                                <span class="input-group-addon" >Окончание</span>
                                <input type='text' class="form-control" id="taskEndTime"/>
                                <span class="input-group-addon">
							<span class="glyphicon glyphicon-calendar"></span>
						</span>
                            </div>
                        </div>
                    </div>
                    <div class="row top-buffer-2">
                        <div class="col-md-12">
                            <div class="form-group">
                                <div class="input-group-addon textarea-addon">Дополнительная информация</div>
                                <textarea class="form-control noresize textarea-for-modal" rows="5"
                                          id="taskAddInfo"></textarea>
                            </div>
                        </div>
                    </div>
                    <ul class="list-group list-group-my">
                        <li class="list-group-item">
                            Сохранить шаблон
                            <div class="material-switch pull-right">
                                <input id="SaveTemplateCheckBox" type="checkbox"/>
                                <label for="SaveTemplateCheckBox" class="label-primary"></label>
                            </div>
                        </li>
                    </ul>
                </div>
                <!-- Футер модального окна -->
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Закрыть</button>
                    <button type="button" class="btn btn-primary" id="modalAddButton">Добавить</button>
                </div>
            </div>
        </div>
    </div>
    <div id="log"></div>
</div>

<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/tags.js"></script>

<script type="text/javascript">

    // Нажатие Enter в поле ввода чата
    $('#messageInput').keyup(function(e){
        if(e.keyCode == 13) {
            sendMessageChat();
        }
    });

    $('#messageSendButton').click(function(e){
        sendMessageChat();
    });

    $("#cardsholderItems").mCustomScrollbar({
        scrollInertia: 275
    });

    // Нажатие кнопки "Пригласить"
    $("#inviteButton").click(function () {
        alert($('#inviteAtMeetingSelectPicker').val());
        $('#inviteAtMeetingSelectPicker').selectpicker('deselectAll');
    });
    // Лимит числа символов в сообщении
    $(function () {
        var text_max = 70;
        $('#textarea_feedback').html('Осталось символов: ' + text_max);

        $('#messageInput').keydown(function () {
            var text_length = $('#messageInput').val().length;
            var text_remaining = text_max - text_length;

            $('#textarea_feedback').html('Осталось символов: ' + text_remaining);
        });
    });

    // Modal datetimepickers для создания новой задачи
    $(function () {
        $('#datetimepicker1').datetimepicker({
            locale: 'ru'
            //format: "DD/MM/YYYY hh:mm"
        });
        $('#datetimepicker2').datetimepicker({
            locale: 'ru',
            useCurrent: false
        });
        $("#datetimepicker1").on("dp.change", function (e) {
            $('#datetimepicker2').data("DateTimePicker").minDate(e.date);
        });
        $("#datetimepicker2").on("dp.change", function (e) {
            $('#datetimepicker1').data("DateTimePicker").maxDate(e.date);
        });
    });
    // Нажатие кнопки под шаблонами
    document.getElementById('messageSendButton').onclick = function () {

    };
    // Нажатие кнопки "Добавить" в всплывающем окне
    document.getElementById('modalAddButton').onclick = function () {
        $('#taskmodal').modal('hide');
    };
</script>

<script type="text/javascript">
    // TIMELINE FILL, SETUP AND CREATE
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    var container = document.getElementById('visualization');

    // Группы элементов (1 группа - 1 пользователь)
    var groups = new vis.DataSet();
    groups.add([

        <c:forEach items="${meeting.memberUsers}" var="user">
        {
            id: ${user.id},
            content: "<a href='/user${user.id}'>${user.name} ${user.middleName} ${user.surname}</a>",
        },
        </c:forEach>
        {
            id: 0,
            content: "<b>Расписание встречи</b>"
        }
    ]);


    // Create a DataSet (allows two way data-binding)
    var items = new vis.DataSet([

        <c:forEach items="${meeting.memberUsers}" var="user">
        <c:forEach items="${user.eventsUser}" var="event">
        {
            <c:choose>
                <c:when test="${user.id == currentUser.id && meeting.date_edit != null}">
                    editable: true,
                </c:when>
                <c:otherwise>
                    editable: false,
                </c:otherwise>
            </c:choose>

            id: ${event.id},
            group: ${user.id},
            content: '${event.name}',
            start: new Date(getDateFromString('${event.date_begin}')),
            end: new Date(getDateFromString('${event.date_end}')),
            className: '${event.priority}'
        },
        </c:forEach>
        </c:forEach>
        {id: 'A', group: 0, type: 'background', start: new Date(getDateFromString('${meeting.date_start}')), end: new Date(getDateFromString('${meeting.date_end}')), className: 'negative'} // Подсветка времени встречи

    ]);

    // Configuration for the Timeline
    var options = {
        locale: 'RU',
        // ЕСЛИ ЭТО СОЗДАТЕЛЬ ВСТРЕЧИ - ЗНАЧЕНИЕ TRUE, ИНАЧЕ - FALSE
        editable: true,
        selectable: true,
        stack: false,
        multiselect: true,
        dataAttributes: 'all',
        snap: null,
        start: new Date(getDateFromString('${meeting.date_start}')).setHours(0,0,0,0),

        // Добавление задачи
        onAdd: function (item, callback) {
            callback(null);
        },

        // Перемещение задачи
        onMove: function (item, callback) {
            $.ajax({
                url : '/userChangeEventAtMeeting/' + item.id,
                type: 'POST',
                dataType: 'json',
                data : {
                    name: item.content,
                    priority: item.className,
                    date_begin: toLocaleDateTimeString(item.start),
                    date_end: toLocaleDateTimeString(item.end)
                },
                success: function (data) {
                    callback(item);
                    createTooltip();
                }
            });
        },

        // Удаление задачи
        onRemove: function (item, callback) {
            callback(null);
        },

        // Обновление задачи
        onUpdate: function (item, callback) {
            callback(null);
        }
    };
    // Create a Timeline
    var timeline = new vis.Timeline(container, items, groups, options);
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////

    // Вывод информации, при наведении на элемент
    function createTooltip() {
        Tipped.create('.vis-item', function (element) {
                var itemId = $(element).attr('data-id');
                var item = items.get(itemId);
                return {
                    title: item.content,
                    content: toLocaleDateTimeString(item.start) + ' - ' + toLocaleDateTimeString(item.end)
                }
            },
            {
                position: 'bottom',
                behavior: 'hide',
                cache: false
            }
        );
    }

    // Преобразовать дату в строку формата DD.MM.YYYY hh:mm
    function toLocaleDateTimeString(dateString) {
        var eventTime = dateString.toLocaleTimeString();
        var eventTimeAfter = eventTime.substring(0, eventTime.length - 3);
        if (eventTimeAfter.length < 5)
            eventTimeAfter = '0' + eventTimeAfter;
        var startDate = dateString.toLocaleDateString() + ' ' + eventTimeAfter;
        return startDate;
    }

    // Получить дату из строки вида DD.MM.YYYY hh:mm
    function getDateFromString(dateString) {
        var reggie = /(\d{2}).(\d{2}).(\d{4}) (\d{2}):(\d{2})/;
        var dateArray = reggie.exec(dateString);
        var dateObject = new Date(
            (+dateArray[3]),
            (+dateArray[2]) - 1, // Careful, month starts at 0!
            (+dateArray[1]),
            (+dateArray[4]),
            (+dateArray[5])
        );
        return dateObject;
    }

    // Просмотр сегодняшнего дня
    document.getElementById('showTodayButton').onclick = function () {
        var currentDate = new Date();
        currentDate.setHours(0, 0, 0, 0);
        var nextDay = new Date(currentDate);
        nextDay.setDate(nextDay.getDate() + 1);
        timeline.setWindow(currentDate, nextDay);
    };

    // Просмотр недели
    document.getElementById('showWeekButton').onclick = function () {
        var currentDate = new Date();
        var monday = new Date();
        currentDate.setHours(0, 0, 0, 0);
        var day = currentDate.getDay() || 7;
        if (day !== 1)
            monday.setHours(-24 * (day - 1));
        var inWeek = new Date(monday);
        inWeek.setDate(monday.getDate() + 7);
        timeline.setWindow(monday, inWeek);
    };

    // Просмотр месяца
    document.getElementById('showMonthButton').onclick = function () {
        var currentDate = new Date();
        currentDate.setHours(0, 0, 0, 0);
        var firstDay = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1);
        var lastDay = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 1);
        timeline.setWindow(firstDay, lastDay);
    };

    // Просмотр года
    document.getElementById('showYearButton').onclick = function () {
        var currentDate = new Date();
        currentDate.setHours(0, 0, 0, 0);
        var firstDay = new Date(currentDate.getFullYear(), 0, 1);
        var lastDay = new Date(currentDate.getFullYear(), 12, 0);
        timeline.setWindow(firstDay, lastDay);
    };

    // Просмотр встречи
    document.getElementById('showMeetingButton').onclick = function () {
        var start = new Date(getDateFromString('${meeting.date_start}'));
        var end = new Date(getDateFromString('${meeting.date_end}'));
        timeline.setWindow(start, end);
    };
    createTooltip();
</script>
</body>
<div style="margin-bottom: 8rem;"/>
<%@include file='footer.jsp'%>
</html>
