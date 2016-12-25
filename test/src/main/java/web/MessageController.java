package web;

import domain.Message;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import service.MessageService;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;

/**
 * Created by Hroniko (Anatoly Bedarev) on 25.12.2016.
 */
@Controller
@SessionAttributes("message")
public class MessageController {
    @Autowired
    MessageService messageService;

    private java.sql.Date strToDate(String str) {
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        java.sql.Date date = null;
        try {
            date = new java.sql.Date(dateFormat.parse(str).getTime());
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return date;
    }

    @RequestMapping(value = "/message", method = RequestMethod.GET)
    public String getRegistrationUserPage() {
        return "/message";
    }

    @RequestMapping(value = "/message", method = RequestMethod.POST)
    public String createMessage(@ModelAttribute("userMessage") Message message,
                              @RequestParam("date_beginStr") String date_begin
    )
    {

        java.sql.Date beginDate = strToDate(date_begin);

        message.setDate_begin(beginDate);
        messageService.createMessage(message);
        return "/main";
    }

}
