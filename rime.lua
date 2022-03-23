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
balance_candidate_filter = require("balance_candidate")
secondary_code_filter = require("secondary_code")
-- ]]
