package service.id_filters;

/**
 * Created by Hroniko on 16.02.2017.
 * Класс-фильтр для встреч
 */
public class MeetingFilter extends BaseFilter {

    public static final String ALL = "all";
    public static final String FOR_DUPLICATE = "for_duplicate";
    public static final String FOR_CURRENT_USER = "for_current_user";
    public static final String FOR_USER_WITH_NAME = "for_user_with_name";
    public static final String FOR_USER_WITH_ID = "for_user_with_id";
    public static final String DELETED_MEETING_FOR_USER = "deleted_meeting_for_user";

    public static final String BETWEEN_USERS_WITH_NAMES = "between_users_with_names";
    public static final String BETWEEN_USERS_WITH_IDS = "between_users_with_ids";
    public static final String BETWEEN_TWO_DATES = "between_two_dates";
    public static final String BEFORE_DATE = "before_date";
    public static final String AFTER_DATE = "after_date";

    public MeetingFilter(String... params) {
        super();
        // Размещаем константы, определяющие фильтр, по мапам, определяющим количество параметров у фильтра
        count_0.put(ALL, "");
        count_0.put(FOR_CURRENT_USER, "");

        count_1.put(FOR_DUPLICATE, "");
        count_1.put(FOR_USER_WITH_NAME, "");
        count_1.put(FOR_USER_WITH_ID, "");
        count_1.put(DELETED_MEETING_FOR_USER, "");
        count_1.put(BEFORE_DATE, "");
        count_1.put(AFTER_DATE, "");


        count_2.put(BETWEEN_TWO_DATES, "");

        count_var.put(BETWEEN_USERS_WITH_NAMES , "");
        count_var.put(BETWEEN_USERS_WITH_IDS , "");

        // Переносим все параметры:
        addManyParams(params);
    }
}
