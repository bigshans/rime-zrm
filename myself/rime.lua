-- translator [[
date_translator = require("date")
time_translator = require("time")
week_translator = require("week")
-- ]]

-- filter [[
-- 过滤含 CJK 扩展的汉字候选项
local charset = require("charset")
charset_filter = charset.filter
charset_comment_filter = charset.comment_filter
single_char_filter = require("single_char")
balance_candidate_filter = require("balance_candidate")
secondary_code_filter = require("secondary_code")
local emoji = require("emoji_filter")
emoji_filter = emoji.filter
emoji_translator = emoji.translator
remove_duplicate_filter = require("remove_duplicate")
-- ]]
select_character_processor = require("select_character")
