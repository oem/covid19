module DashboardTests exposing (..)

import Dashboard exposing (Cell(..), severityClass)
import Expect exposing (Expectation)
import Test exposing (..)


severityClass1 : Test
severityClass1 =
    test "when today has no value"
        (\_ -> Expect.equal "bg-gray-300" (severityClass (Today Nothing)))


severityClass2 : Test
severityClass2 =
    test "produces bg-red-500 for Today Just 180"
        (\_ -> Expect.equal "bg-red-500" (severityClass <| Today (Just 180)))
