#!/bin/zsh
# Regenerate every compare/NN-*.jpg from the current build (row specs as in tools/compare.sh).
# COMPOSE_ONLY=1 re-lays out the sheets from the screenshots already in verify/ios/.
set -e
T=${0:A:h}  # this tools/ directory
[[ -n $COMPOSE_ONLY ]] || $T/build-catalog.sh
$T/compare.sh 01 loading-state "Loading State" drive:end:Drive:3 dots:end:Dots:3 orbit:end:Orbit:3 surfer:end:Surfer:3
$T/compare.sh 02 thinking-state "Thinking" steps:t2200:Steps:2.4 steps:t4800:Steps:5.0 reasoning:t4800:Reasoning:5.0 search:t4800:Search:5.0 coding:t4800:Coding:5.0 steps:end:Steps:9
$T/compare.sh 03 streaming-text "Streaming Text" default:t1000:-:1.2 default:done:-:3.4 default:sources:-:3.6:sources
$T/compare.sh 04 approval-card "Approval Card" default:q1:-:1.5 default:q2:-:1.5:q2 default:sent:-:1.5:sent
$T/compare.sh 05 tool-chips "Tool Chips" default:t1800:-:1.8 default:done:-:4.2 default:row:-:4.2:row default:diff:-:4.2:diff:160
$T/compare.sh 06 task-rows "Task Rows" capsules:t1100:Capsules:1.4 capsules:t2600:Capsules:2.9 capsules:t4500:Capsules:4.8 capsules:t6500:Capsules:6.8 list:t2600:List:2.9 list:t6500:List:6.8
$T/compare.sh 07 chat-composer "Chat" default:done:-:2.5 default:done:-:2.5:resolving
$T/compare.sh 08 prompt-bar "Prompt Bar" rounded:t1700:Rounded:1.5:step1 rounded:t4500:Rounded:1.5:step5 rounded:t6100:Rounded:1.5:step7 rounded:t9600:Rounded:1.5:step11 rounded:t11600:Rounded:2.5:step12 pill:t1700:Pill:1.5:step1
$T/compare.sh 09 recommendation-card "Recommendation Card" default:view:-:1.5 default:alternatives:-:1.5:alternatives default:review:-:1.5:review
$T/compare.sh 10 context-cards "Context Cards" default:view:-:2
$T/compare.sh 11 diff-table "Diff Table" default:view:-:1.5
$T/compare.sh 12 records-table "Records Table" default:view:-:2 default:view:-:3:ai
$T/compare.sh 13 filter-table "Filter Table" default:view:-:1.5 default:progress:-:1.5:progress
$T/compare.sh 14 sidebar-nav "Sidebar Nav" default:view:-:1.5 default:workspace:-:1.5:workspace default:search:-:1.5:search default:collapsed:-:1.5:collapsed
$T/compare.sh 15 search "Search" default:view:-:1.5 "default:picked:-:1.5:Find waffle cone suppliers"
$T/compare.sh 16 flowchart "Flowchart" default:view:-:1.5 default:selected:-:1.5:selected
$T/compare.sh 17 insight-cards "Insight Cards" default:p1:-:1.5 default:p2:-:1.5:1 default:p3:-:1.5:2
$T/compare.sh 18 code-block "Code Block" code:view:Code:1.5 diff:view:Diff:1.5
$T/compare.sh 19 fine-tune-card "Fine-tune Card" default:view:-:1.5 default:menu:-:1.5:menu default:view:-:1.5:edited
$T/compare.sh 20 selection-actions "Selection Actions" default:idle:-:1.5 default:thinking:-:0.9:thinking default:result:-:1.5:result default:expanded:-:1.5:expanded
$T/compare.sh 21 agent-screen "Agent Screen" working:view:Working:1.5 loading:view:Loading:1.5 working:view:Working:1.5:recording
echo "ALL COMPARES DONE"
