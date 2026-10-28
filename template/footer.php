<?php defined('ROOTPATH') || die('Denied access to: '.__FILE__); ?>
<table id="footer">
    <tr>
        <td colspan="5">
            <!-- The log. -->
            <input id="log-toggle" type="checkbox" />
            <label id="log" for="log-toggle"><?php if(isset($_SESSION['log'])) echo htmlspecialchars($_SESSION['log']); ?></label>
        </td>
        <td colspan="3">

        </td>
        <td>
            <?php
                $code = http_response_code();
                echo 'Response: '.$code.' '.http_status_message($code);
            ?>
        </td>
        <td>
            <a class="ajax" href="/policy#privacy">Privacy Policy</a>
        </td>
        <td id="chat">
            <!-- The chat. -->
            <input id="chat-toggle" type="checkbox" />
            <label for="chat-toggle">Chat</label>
            <table>
                <tr>
                    <td colspan="5" rowspan="3">
                        <fieldset id="chat-messages"></fieldset>
                    </td>
                    <td colspan="2" rowspan="3">Users</td>
                </tr>
                <tr></tr>
                <tr></tr>
                <tr>
                    <td colspan="4"><input type="text" name="message" /></td>
                    <td colspan="1"><div><input type="button" name="send" value="Send" /></div></td>
                    <td colspan="2">Settings</td>
                </tr>
            </table>

        </td>
        <td>
            <!-- Scroll-to-the-top-of-the-page link. -->
            <a href="<?php echo $uri->path; ?>#top" onclick="event.preventDefault(); document.body.scrollTop = document.documentElement.scrollTop = 0;">Top of Page</a>
        </td>
        <td colspan="2" id="benchmark">
            <?php echo 'Page generated in: '.number_format((microtime(true) - $_SERVER['REQUEST_TIME_FLOAT']) * 1000, 3).' ms'; ?>
        </td>
    </tr>
</table>
