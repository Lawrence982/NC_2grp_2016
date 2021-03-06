package web;

import com.google.common.cache.LoadingCache;
import com.google.gson.Gson;
import dbHelp.DBHelp;
import exception.CustomException;
import service.converter.Converter;
import entities.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import service.LoadingServiceImp;
import service.MeetingServiceImp;
import service.UserServiceImp;
import service.cache.DataObjectCache;
import service.converter.DateConverter;
import service.id_filters.MeetingFilter;
import service.id_filters.UserFilter;
import service.notifications.NotificationService;
import service.notifications.UsersNotifications;
import service.search.FinderLogic;
import service.search.FinderTagRequest;
import service.search.FinderTagResponse;
import service.search.SearchParser;
import service.statistics.StatisticLogger;
import service.tags.TagNodeTree;
import service.tags.TagTreeManager;

import javax.mail.MessagingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;

/**
 * Created by Костя on 07.02.2017.
 */
@Controller
public class MeetingController {
    // Собственный внутренний логгер для контроллера
    private StatisticLogger loggerLog = new StatisticLogger();
    private Converter converter = new Converter();
    private UserServiceImp userService = new UserServiceImp();

    private TagTreeManager tagTreeManager = new TagTreeManager();

    private TagNodeTree tagNodeTree = TagNodeTree.getInstance();

    private Logger logger = LoggerFactory.getLogger(MeetingController.class);

    private LoadingCache<Integer, DataObject> doCache = DataObjectCache.getLoadingCache();
    private MeetingServiceImp meetingService = MeetingServiceImp.getInstance();
    private LoadingServiceImp loadingService = new LoadingServiceImp();

    public MeetingController() throws IOException {
    }

    private ArrayList<DataObject> getListDataObject(Map<Integer, DataObject> map) {
        ArrayList<DataObject> list = new ArrayList<>();
        for (Map.Entry<Integer, DataObject> e : map.entrySet()) {
            list.add(e.getValue());
        }
        return list;
    }

    @RequestMapping(value = "/viewMeeting/{meetingID}", method = RequestMethod.GET)
    public String getMeetingPage(@PathVariable("meetingID") Integer meetingID,
                                 ModelMap m) throws InvocationTargetException, SQLException, IllegalAccessException, NoSuchMethodException {
        ArrayList<Meeting> meetingArrayList = new ArrayList<>();
        DataObject currentUser = loadingService.getDataObjectByIdAlternative(userService.getObjID(userService.getCurrentUsername()));
        User user = converter.ToUser(currentUser);
        Meeting meeting = new Meeting();
        try {
            meeting = new Meeting(doCache.get(meetingID));
        } catch (ExecutionException e) {
            e.printStackTrace();
        }
        meetingArrayList.add(meeting);
        String status = "guest";
        if (meeting.getMemberUsers().contains(user)) {
            status = "user";
        }
        m.addAttribute("status", status);
        m.addAttribute("meetings", meetingArrayList);

        return "/meetings";
    }

    // Список встреч пользователя
    @RequestMapping(value = "/meetingsUser/{userID}", method = RequestMethod.GET)
    public String getUserMeetingsPage(@PathVariable("userID") Integer userID, ModelMap m) throws SQLException, ExecutionException, NoSuchMethodException, IllegalAccessException, InvocationTargetException, CustomException {

        User user = converter.ToUser(doCache.get(userID));
        User currentUser = converter.ToUser(doCache.get(userService.getObjID(userService.getCurrentUsername())));
        Settings settings = converter.ToSettings(doCache.get(user.getSettingsID()));
        ArrayList<Integer> ilFriend = loadingService.getListIdFilteredAlternative(new UserFilter(UserFilter.ALL_FRIENDS_FOR_USER_WITH_ID, String.valueOf(user.getId())));
        if (("onlyFriend".equals(settings.getPrivateProfile()) && ilFriend.contains(currentUser.getId())) || ("any".equals(settings.getPrivateProfile()))) {

            ArrayList<Integer> il = loadingService.getListIdFilteredAlternative(new MeetingFilter(MeetingFilter.FOR_USER_WITH_ID, String.valueOf(user.getId())));

            Map<Integer, DataObject> map = doCache.getAll(il);
            ArrayList<DataObject> list = getListDataObject(map);
            ArrayList<Meeting> meetings = new ArrayList<>(list.size());
            for (DataObject dataObject : list) {
                Meeting meeting = new Meeting(dataObject);
                meetings.add(meeting);
            }

            m.addAttribute("meetings", meetings);
            m.addAttribute("user", currentUser);
        } else throw new CustomException("Пользователь ограничил доступ к этой странице");
        return "/meetings";
    }

    // Список встреч пользователя
    @RequestMapping(value = "/meetings", method = RequestMethod.GET)
    public String getMeetingsPage(HttpServletRequest request, ModelMap m) throws InvocationTargetException, NoSuchMethodException, SQLException, IllegalAccessException, ExecutionException, CustomException {
        HttpSession session = request.getSession();
        if (session.getAttribute("finder") != null) {
            FinderTagRequest finder = (FinderTagRequest) session.getAttribute("finder");
            System.out.println("finder пришел из сессии!!!" + finder.getText());

            if ("meeting".equals(finder.getType())) {
                ArrayList<FinderTagResponse> finderTagResponseList = FinderLogic.getWithLogic(finder);
                Set<Integer> meetingsID = new HashSet<>();
                ArrayList<Integer> meetingsListWithTag;

                assert finderTagResponseList != null;
                for (FinderTagResponse tag : finderTagResponseList
                        ) {

                    String value = tag.getText();
                    meetingsListWithTag = tagTreeManager.getMeetingListWithTag(value);
                    meetingsID.addAll(meetingsListWithTag);
                }


                try {
                    DataObject dataObjectUser = doCache.get(userService.getObjID(userService.getCurrentUsername()));
                    User user = converter.ToUser(dataObjectUser);
                    Map<Integer, DataObject> map = doCache.getAll(meetingsID);
                    ArrayList<DataObject> list = getListDataObject(map);
                    ArrayList<Meeting> meetings = new ArrayList<>(list.size());
                    for (DataObject dataObject : list) {
                        Meeting meeting = new Meeting(dataObject);
                        meetings.add(meeting);
                    }

                    m.put("meetings", meetings);
                    m.addAttribute("user", user);

                    session.removeAttribute("finder");

                } catch (ExecutionException e) {
                    e.printStackTrace();
                }
            } else {
                throw new CustomException("Неизвестная ошибка!");
            }
        } else {
            try {
                DataObject dataObjectUser = doCache.get(userService.getObjID(userService.getCurrentUsername()));
                User user = converter.ToUser(dataObjectUser);

                ArrayList<Integer> il = loadingService.getListIdFilteredAlternative(new MeetingFilter(MeetingFilter.FOR_CURRENT_USER));
                ArrayList<Integer> deletedMeeting = loadingService.getListIdFilteredAlternative(new MeetingFilter(MeetingFilter.DELETED_MEETING_FOR_USER, dataObjectUser.getName()));

                il.removeAll(deletedMeeting);

                Map<Integer, DataObject> map = doCache.getAll(il);
                ArrayList<DataObject> list = getListDataObject(map);
                ArrayList<Meeting> meetings = new ArrayList<>(list.size());
                for (DataObject dataObject : list) {
                    Meeting meeting = new Meeting(dataObject);
                    meetings.add(meeting);
                }

                m.addAttribute("meetings", meetings); // m.addAttribute("meetings", meetingService.getUserMeetingsList(idUser));
                m.addAttribute("user", user);

                return "meetings";

            } catch (ExecutionException e) {
                e.printStackTrace();
            }
        }
        /*
        user = userService.getCurrentUser(); // Получаем Объект текущего пользователя
        Integer idUser = userService.getObjID(userService.getCurrentUsername());
        m.addAttribute("meetings", meetingService.getUserMeetingsList(idUser)); // m.addAttribute("meetings", meetingService.getUserMeetingsList(idUser));
        */

        // Логируем:
        int idUser = userService.getObjID(userService.getCurrentUsername());
        loggerLog.add(Log.PAGE, "meetings", idUser);
        return "meetings";
    }

    // Просмотр встречи DO
    @RequestMapping(value = "/meeting{meetingID}", method = RequestMethod.GET)
    public String getMeetingPage(ModelMap m, @PathVariable("meetingID") Integer meetingID) throws InvocationTargetException, SQLException, IllegalAccessException, NoSuchMethodException, ExecutionException, ParseException, CustomException {
        Meeting meeting = new Meeting();
        try {
            meeting = new Meeting(doCache.get(meetingID));
        } catch (ExecutionException e) {
            e.printStackTrace();
        }

        // Выпиливаются приглашённые друзья
        ArrayList<User> meetingUsers = meeting.getMemberUsers();
        ArrayList<User> organizerFriends = meeting.getOrganizer().getFriends();
        organizerFriends.removeAll(meetingUsers);
        m.addAttribute("meeting", meeting); // Добавление информации о событии на страницу

        // Логируем:
        int idUser = userService.getObjID(userService.getCurrentUsername());
        loggerLog.add(Log.PAGE, "meeting", idUser);

        DataObject dataObject = doCache.get(userService.getObjID(userService.getCurrentUsername()));
        User user = converter.ToUser(dataObject);

        ArrayList<Integer> listIds = new ArrayList<>();
        for (User user_id : meetingUsers
                ) {
            listIds.add(user_id.getId());
        }
        m.addAttribute("ids", listIds);
        m.addAttribute("currentUser", user);

        if (meeting.getOrganizer().getId() == userService.getObjID(userService.getCurrentUsername())) // Страницу запрашивает создатель встречи
            return "/meetingAdmin";
        else if (meeting.getMemberUsers().contains(user)) { // Страницу запрашивает участник встречи
            return "/meetingMember";
        } else {
            throw new CustomException("Вы не можете просмотреть эту встречу, так как не являетесь ее участником. Попроситесь или напишите организатору");
        }

    }

    //Добавление встречи DO
   /* @RequestMapping(value = "/addMeeting", method = RequestMethod.POST)
    public String addMeeting(ModelMap m,
                             @RequestParam("title") String title,
                             @RequestParam("tag") String tag,
                             @RequestParam("date_start") String date_start,
                             @RequestParam("date_end") String date_end,
                             @RequestParam("info") String info) throws InvocationTargetException, SQLException, IllegalAccessException,
            NoSuchMethodException, ParseException {

        int id = userService.generationID(1004);

        StringBuilder worlds = new StringBuilder();

        if (!Objects.equals(tag, "")) {
            ArrayList<String> tags = SearchParser.parse(tag);
            assert tags != null;
            for (String value : tags
                    ) {
                tagNodeTree.insertForMeeting(value, id);
                System.out.println("КИНУЛ ID" + id);
                worlds.append(value).append(" ");
            }
        } else worlds.append("встреча");

        long duration = DateConverter.duration(date_start, date_end);

        Meeting meeting = new Meeting(id, title, date_start, date_end, info, userService.getCurrentUser(), worlds, "", String.valueOf(duration));

        ArrayList<User> users = new ArrayList<>();
        User user = new User();
        user.setId(meeting.getOrganizer().getId());
        users.add(user);
        meeting.setUsers(users);

        DataObject dataObject = meeting.toDataObject();

        loadingService.setDataObjectToDB(dataObject);
        doCache.invalidate(id);



        // Логирование:
        int idUser = userService.getObjID(userService.getCurrentUsername());
        loggerLog.add(Log.ADD_MEETING, id, idUser);
        return "redirect:/meetings";
    }  */

    //отклонить приглашение на встречу
    @RequestMapping("/declineInviteMeeting/{objectId}")
    public String declineInviteMeeting(@PathVariable("objectId") Integer objectId,
                                       ModelMap m) throws InvocationTargetException, NoSuchMethodException, SQLException, IllegalAccessException {
        User user = converter.ToUser(loadingService.getDataObjectByIdAlternative(userService.getObjID(userService.getCurrentUsername())));

        Meeting meeting = null;
        try {
            meeting = new Meeting(doCache.get(objectId));
            meeting.addRefusedUsers(user);
            loadingService.updateDataObject(meeting.toDataObject());
            doCache.refresh(meeting.getId());
            System.out.println("Размер листа пользователей, приглашенных создателем встречи " + meeting.getInvitedUsers().size());
            System.out.println("Размер листа пользователей, отклонивших приглашение " + meeting.getRefusedUsers().size());
        } catch (ExecutionException e) {
            e.printStackTrace();
        }

        String message1 = "Стать участником";
        String message2 = "Приглашение на встречу успешно отклонено";
        m.addAttribute("info1", message1);
        m.addAttribute("info2", message2);
        loggerLog.add(Log.DECLINE_INVITE_MEETING, objectId, user.getId()); // Отказ от приглашения на встречу
        return "info";
    }

    //отклонить запрос пользователя на участие в встрече
    @RequestMapping("/declineRequestMeeting/{objectId}/{senderID}")
    public String declineRequestMeeting(@PathVariable("objectId") Integer objectId,
                                        @PathVariable("senderID") Integer senderID,
                                        ModelMap m) throws InvocationTargetException, NoSuchMethodException, SQLException, IllegalAccessException {
        int idUser = userService.getObjID(userService.getCurrentUsername());
        String message1 = "Принять пользователя";
        String message2 = "Запрос успешно отклонен";
        m.addAttribute("info1", message1);
        m.addAttribute("info2", message2);
        loggerLog.add(Log.DECLINE_REQUEST_MEETING, idUser, objectId); // Отказ принять пользователя на встречу

        // 2017-05-15 Поправка на смену групп пользователя встречи
        // Получаем встречу:
        DataObject currentUser = loadingService.getDataObjectByIdAlternative(senderID);
        User user = converter.ToUser(currentUser);
        Meeting meeting = null;
        try {
            meeting = new Meeting(doCache.get(objectId));
            // и переводим юзера в разряд тех, кому администратор отказал во встрече
            meeting.addDeletedUsers(user);
            loadingService.updateDataObject(meeting.toDataObject());
            doCache.refresh(meeting.getId());
        } catch (ExecutionException e) {
            e.printStackTrace();
        }

        System.out.println("Размер листа с пользователями желающие принять участие " + meeting.getBeggingUsers().size());
        System.out.println("Размер листа с пользователями удаленные администратором " + meeting.getDeletedUsers().size());

        return "info";
    }

    // Добавить пользователя на встречу DO, 2017-04-11 добавил создание уведомления о добавлении ко встрече для юзеров
    @RequestMapping(value = "/inviteUserAtMeeting/{meetingID}/{userID}")
    public String inviteUserAtMeeting(@PathVariable("userID") Integer userID,
                                      @PathVariable("meetingID") Integer meetingID) throws SQLException, NoSuchMethodException,
            IllegalAccessException, InvocationTargetException, ExecutionException, ParseException, IOException, MessagingException {


        Meeting meeting = new Meeting();
        try {
            meeting = new Meeting(doCache.get(meetingID));
        } catch (ExecutionException e) {
            e.printStackTrace();
        }
        // int idSender = userService.getCurrentUser().getId(); // получаем айди текущего юзера (он создатель встречи и отправитель приглашения на встречу)
        //ArrayList<User> userList = meeting.getInvitedUsers();   //исправлено


        // Приглашаемый юзер (и он же получатель уведомления)
        User user = new User(doCache.get(userID));

        if (meeting.getBeggingUsers().contains(user)) {
            meeting.addInvitedUsers(user);
        } else meeting.addAcceptedUsers(user);
        //userList.add(user);
        //добавляю дубликат
        meeting.createDuplicate(user.getId());

        // meeting.setUsers(userList); // Не нужно, он автоматически ляжет там, когда пройдет addInvitedUsers()


        DataObject dataObject = meeting.toDataObject();
        loadingService.updateDataObject(dataObject);
        doCache.invalidate(meetingID);


        System.out.println("Размер листа с участниками " + meeting.getMemberUsers().size());
        loggerLog.add(Log.INVITE_MEETING, userID, meetingID); // Принять приглашения на встречу

        return "redirect:/meeting{meetingID}";
    }

    // Покинуть встречу
    @RequestMapping(value = "/leaveMeeting{meetingID}", method = RequestMethod.GET)
    public String leaveMeeting(@PathVariable("meetingID") Integer meetingID) throws SQLException, NoSuchMethodException, IllegalAccessException, InvocationTargetException, ExecutionException {

        Meeting meeting = new Meeting();
        try {
            meeting = new Meeting(doCache.get(meetingID));
        } catch (ExecutionException e) {
            e.printStackTrace();
        }
        DataObject dataObject = doCache.get(userService.getObjID(userService.getCurrentUsername()));
        User user = converter.ToUser(dataObject);


        System.out.println("Размер листа с участниками " + meeting.getMemberUsers().size());
        System.out.println("Размер листа покинувших участников " + meeting.getExitedUsers().size());


        // meeting.getUsers().remove(user);

        if (meeting.getOrganizer().equals(user)) {
            // meeting.getUsers().remove(user);

            meeting.setOrganizer(meeting.getMemberUsers().get(0)); // следующий участник становится организатором // А если всего один участник был? Тогда встречу надо закрыть? Удалить??
        } // else meeting.getUsers().remove(user);


        ArrayList<Integer> ids_duplicates = meeting.getDuplicateIDs();

        for (Integer i : ids_duplicates
                ) {
            DataObject dataObjectDuplicate = doCache.get(i);
            if (dataObjectDuplicate.getReference(141).get(0).equals(user.getId())) {  //если это наш дубликат

                //удаляем юзера из встречи
                meeting.addExitedUsers(user); // Отправляем в группу покинувших встречу

                //удаляем ссылку на дубликат из встречи
                meeting.getDuplicates().remove(dataObjectDuplicate);
            }
        }

        loadingService.updateDataObject(meeting.toDataObject());
        doCache.invalidate(meetingID);

        //удаляем дубликаты
        for (Integer i : ids_duplicates
                ) {
            DataObject dataObjectDuplicate = doCache.get(i);
            if (dataObjectDuplicate.getReference(141).get(0).equals(user.getId())) {
                System.out.println("Дубликат встречи удален");
                loadingService.deleteDataObjectById(dataObjectDuplicate.getId());
                doCache.invalidate(i);
            }
        }

        doCache.invalidate(meetingID);

        // Логирование:
        loggerLog.add(Log.LEAVED_MEETING, meetingID);
        return "redirect:/meetings";
    }

    // Редактирование встречи DO
    @RequestMapping(value = "/updateMeeting{meetingID}", method = RequestMethod.POST)
    public String inviteUserAtMeeting(@PathVariable("meetingID") Integer meetingID,
                                      @RequestParam("title") String title,
                                      @RequestParam("tag") StringBuilder tag,
                                      @RequestParam("date_start") String date_start,
                                      @RequestParam("date_end") String date_end,
                                      @RequestParam("info") String info) throws InvocationTargetException, SQLException, IllegalAccessException, NoSuchMethodException, ParseException {

        Meeting meeting = meetingService.getMeeting(meetingID);
        meeting.setTitle(title);
        meeting.setTag(tag);
        meeting.setDate_start(date_start);
        meeting.setDate_end(date_end);
        meeting.setDuration(String.valueOf(DateConverter.duration(date_start, date_end)));
        meeting.setInfo(info);
        DataObject dataObject = meeting.toDataObject();
        int id = loadingService.updateDataObject(dataObject);
        doCache.invalidate(meetingID);

        // Логирование:
        int idUser = userService.getObjID(userService.getCurrentUsername());
        loggerLog.add(Log.EDIT_MEETING, id, idUser);
        return "redirect:/meeting{meetingID}";
    }

    // Редактирование встречи Ajax
    @RequestMapping(value = "/updateMeetingAJAX{meetingID}", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    public
    @ResponseBody
    Response inviteUserAtMeetingWithAJAX(
            @PathVariable("meetingID") Integer meetingID,
            @RequestParam("title") String title,
            @RequestParam("tag") StringBuilder tag,
            @RequestParam("date_start") String date_start,
            @RequestParam("date_end") String date_end,
            @RequestParam("info") String info) throws InvocationTargetException, SQLException, IllegalAccessException, NoSuchMethodException, ParseException, ExecutionException {


        Response response = new Response();
        logger.info("asdasd");
        Meeting meeting = meetingService.getMeeting(meetingID);

        StringBuilder worlds = new StringBuilder();

        if (tag != null) {
            ArrayList<String> tags = SearchParser.parse(new String(tag));
            assert tags != null;
            for (String value : tags
                    ) {
                tagNodeTree.insertForMeeting(value, meetingID);
                System.out.println("КИНУЛ ID" + meetingID);
                worlds.append(value).append(" ");
            }
        }

        meeting.setTitle(title);
        meeting.setTag(worlds);
        meeting.setDate_start(date_start);
        meeting.setDate_end(date_end);
        meeting.setDuration(String.valueOf(DateConverter.duration(date_start, date_end)));
        meeting.setInfo(info);

        ArrayList<Integer> ids_duplicates = meeting.getDuplicateIDs();
        ArrayList<User> users = meeting.getMemberUsers();
        System.out.println("РАЗМЕР!!!!!!!!!!! " + users.size());


        DataObject dataObject = meeting.toDataObject();
        loadingService.updateDataObject(dataObject);
        doCache.refresh(meetingID);

        for (User user : users
                ) {
            for (Integer i : ids_duplicates
                    ) {
                DataObject dataObjectDuplicate = doCache.get(i);
                if (dataObjectDuplicate.getReference(141).get(0).equals(user.getId())) {
                    loadingService.deleteDataObjectById(dataObjectDuplicate.getId());
                }
            }
        }

        //удаляем ссылки на дубликаты
        for (Integer i : ids_duplicates
                ) {
            DataObject dataObjectDuplicate = doCache.get(i);
            meeting.getDuplicates().remove(dataObjectDuplicate);
            doCache.invalidate(i);
        }

        for (User user : users
                ) {
            meeting.createDuplicate(user.getId());

        }

        dataObject = meeting.toDataObject();
        int id = loadingService.updateDataObject(dataObject);
        doCache.refresh(meetingID);

        // Логирование:
        int idUser = userService.getObjID(userService.getCurrentUsername());
        loggerLog.add(Log.EDIT_MEETING, id, idUser);
        response.setText(new Gson().toJson(meeting));
        return response;
    }

    //удалить встречу
    @RequestMapping(value = "/deleteMeeting{meetingID}", method = RequestMethod.GET)
    public String deleteMeeting(@PathVariable("meetingID") Integer meetingID) throws InvocationTargetException,
            SQLException, IllegalAccessException, NoSuchMethodException, ExecutionException {

        DataObject currentUser = loadingService.getDataObjectByIdAlternative(userService.getObjID(userService.getCurrentUsername()));
        User user = converter.ToUser(currentUser);
        new DBHelp().setDeletedMeeting(user.getId(), meetingID);


        // Логирование:
        int idUser = userService.getObjID(userService.getCurrentUsername());
        loggerLog.add(Log.DELETED_MEETING, meetingID, idUser);
        return "redirect:/meetings";
    }

    //закрыть встречу
    @RequestMapping(value = "/closeMeeting{meetingID}", method = RequestMethod.GET)
    public String closeMeeting(@PathVariable("meetingID") Integer meetingID) throws InvocationTargetException,
            SQLException, IllegalAccessException, NoSuchMethodException, ExecutionException {

        DataObject dataObject = doCache.get(meetingID);
        Meeting meeting = new Meeting(dataObject);
        meeting.setStatus("closed");

        //удаляю ссылки на дубликаты из встречи
        ArrayList<Integer> ids_duplicates = meeting.getDuplicateIDs();
        for (Integer i : ids_duplicates
                ) {
            DataObject dataObjectDuplicate = doCache.get(i);
            meeting.getDuplicates().remove(dataObjectDuplicate);
        }

        //обновляю встерче перед непосредственным удалением дубликатов
        int id = loadingService.updateDataObject(meeting.toDataObject());
        doCache.invalidate(meetingID);

        //удаляем дубликаты
        for (Integer i : ids_duplicates
                ) {
            DataObject dataObjectDuplicate = doCache.get(i);
            System.out.println("Дубликат встречи удален");
            loadingService.deleteDataObjectById(dataObjectDuplicate.getId());
        }

        // Логирование:
        int idUser = userService.getObjID(userService.getCurrentUsername());
        loggerLog.add(Log.CLOSED_MEETING, id, idUser);
        return "redirect:/meetings";
    }
}
