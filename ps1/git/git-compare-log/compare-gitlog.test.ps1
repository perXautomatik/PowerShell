# Import the module that contains the functions to test
Import-Module .\GitLogFunctions.psm1

# Define a test file with the .Tests.ps1 extension
# Use the Describe block to name the test suite
Describe "Compare-GitLog Tests" {

    # Use the Context block to group related tests
    Context "When FileName and CommitSha are valid" {

        # Use the It block to name and write individual tests
        It "Should return an array of objects with the expected fields" {

            # Arrange: set up the test data and parameters
            $FileName = "CollectionHolder.cs"
            $CommitSha = "3a5b6c7"

            # Act: invoke the function to test
            $result = Compare-GitLog -FileName $FileName -CommitSha $CommitSha

            # Assert: use the Should command to verify the expected outcomes
            $result | Should -Not -BeNullOrEmpty
            $result | Should -BeOfType [object[]]
            $result[0] | Should -HaveProperty Hash
            $result[0] | Should -HaveProperty Message
            $result[0] | Should -HaveProperty Removed
            $result[0] | Should -HaveProperty Added
            $result[0] | Should -HaveProperty Modified
        }

        It "Should return the correct statistics for each comparison" {

            # Arrange: set up the test data and parameters
            $FileName = "CollectionHolder.cs"
            $CommitSha = "3a5b6c7"

            # Act: invoke the function to test
            $result = Compare-GitLog -FileName $FileName -CommitSha $CommitSha

            # Assert: use the Should command to verify the expected outcomes
            # You can use the -BeExactly operator to compare strings with case-sensitivity
            $result[0].Hash | Should -BeExactly "3a5b6c7"
            $result[0].Message | Should -BeExactly "Some commit message"
            $result[0].Removed | Should -Be 10
            $result[0].Added | Should -Be 15
            $result[0].Modified | Should -Be 25
        }
    }

    Context "When FileName or CommitSha are invalid" {

        It "Should throw an error if FileName is null or empty" {

            # Arrange: set up the test data and parameters
            $FileName = ""
            $CommitSha = "3a5b6c7"

            # Assert: use the Should command with the -Throw parameter to expect an error
            # You can use a wildcard pattern to match the error message
            { Compare-GitLog -FileName $FileName -CommitSha $CommitSha } | Should -Throw "Cannot validate argument*"
        }

        It "Should throw an error if CommitSha is null or empty" {

            # Arrange: set up the test data and parameters
            $FileName = "CollectionHolder.cs"
            $CommitSha = ""

            # Assert: use the Should command with the -Throw parameter to expect an error
            # You can use a wildcard pattern to match the error message
            { Compare-GitLog -FileName $FileName -CommitSha $CommitSha } | Should -Throw "Cannot validate argument*"
        }

        It "Should throw an error if CommitSha is not a valid git commit" {

            # Arrange: set up the test data and parameters
            $FileName = "CollectionHolder.cs"
            $CommitSha = "abcdefg"

            # Assert: use the Should command with the -Throw parameter to expect an error
            # You can use a wildcard pattern to match the error message
            { Compare-GitLog -FileName $FileName -CommitSha $CommitSha } | Should -Throw "fatal: bad object*"
        }
    }
}

