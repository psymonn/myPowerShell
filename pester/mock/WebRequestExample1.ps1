function foo {
	param()
	Invoke-WebRequest -UseBasicParsing -Uri 'http://yoyomyurl'
}

describe 'test' {
	mock 'Invoke-WebRequest' {
		'invoke-webrequest mocked'
	}

	$result = foo

	it 'should return mocked string' {
		$result | should be 'invoke-webrequest mocked'
	}

	it 'should be mocked' {
		$assMParams = @{
			CommandName = 'Invoke-WebRequest'
			Times = 1
			Exactly = $true
		}
		Assert-MockCalled @assMParams
	}
}
