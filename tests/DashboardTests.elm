module DashboardTests exposing (..)

import Dashboard exposing (Cell(..), severityClass)
import Expect exposing (Expectation)
import Test exposing (..)


severityClassToday1 : Test
severityClassToday1 =
    test "produces bg-gray-300 for Today Nothing"
        (\_ -> Expect.equal "bg-gray-300" (severityClass (Today Nothing)))


severityClassToday2 : Test
severityClassToday2 =
    test "produces bg-red-500 for Today Just 180"
        (\_ -> Expect.equal "bg-red-500" (severityClass <| Today (Just 180)))


severityClassToday3 : Test
severityClassToday3 =
    test "produces dark red gradient for Today Just 280"
        (\_ -> Expect.equal "bg-gradient-to-b from-red-600 to-red-500" (severityClass <| Today (Just 280)))


severityClassToday4 : Test
severityClassToday4 =
    test "produces bg-red-400 for Today Just 110"
        (\_ -> Expect.equal "bg-red-400" (severityClass <| Today (Just 110)))


severityClassToday5 : Test
severityClassToday5 =
    test "produces bg-purple-500 for Today Just 80"
        (\_ -> Expect.equal "bg-purple-500" (severityClass <| Today (Just 80)))


severityClassToday6 : Test
severityClassToday6 =
    test "produces bg-gray-300 for Today Just 20"
        (\_ -> Expect.equal "bg-gray-300" (severityClass <| Today (Just 20)))
