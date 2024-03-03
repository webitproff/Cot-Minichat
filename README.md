* Своя БД
* Отправка сообщения POST запросом, вместо GET
* Редактирование сообщений
* Автообновление только на первой странице чата
* Смайлы
*  Download Siena version 

English
ShoutBox (mini-chat) for Cotonti.
The idea of creation: the plugin Box for seditio.
Features: the division on the rights (read, add, delete messages), auto refresh
It supports AJAX, for all functions - pagination, add and delete messages, chat auto content.
2 modes of Mini-chat: panel mode and window mode.
By default, is supported panel mode only on index.php, but you can easily adapt it for your needs:
Create a copy of minichat.index.php, rename, open the file in Notepad and replace:

 

Hooks = index.tags 

 

for the necessary hook.

Moool13's fork for Siena:

    Uses own DB table
    Sends messages via POST
    Messages are editable
    Auto-update only on 1st page
    Smilies


Russian
Мини-чат для Cotonti.
Идея создания: плагин Box для seditio.
Возможности: разделение на права (чтение, редактирование), добавление, удаление сообщений, автообновление
Поддерживает AJAX, применительно ко всем функциям - навигации по страницам, добавление и удаление сообщений, автообновление содержимого чата.
2 режима работы: в панели и в отдельном окне.
По умолчанию поддерживается на панели только на index.php, но Вы можете легко его адаптировать под ваши нужды:
Создайте копию файла minichat.index.php, переименуйте, откройте файл в блокноте и замените:

Hooks=index.tags

на необходимый Вам хук.

 

Moool13's fork для Siena:

    Использует свою таблицу БД
    Отправляет сообщения через POST
    Редактирование сообщений
    Авто-обновление только на первой странице
    Смайлики
