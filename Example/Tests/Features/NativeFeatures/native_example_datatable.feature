Feature: Simple Feature File Parsing

    Scenario: The sum of a list of numbers should be calculated
        Given a list of numbers
            | 17   |
            | 42   |
            | 4711 |
        When I sum them
        Then I should get 4770
