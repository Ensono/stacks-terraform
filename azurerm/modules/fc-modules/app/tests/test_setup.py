"""Setup the test title

"""
import pytest


@pytest.mark.dev
def test_set_test_title():
    """Set the test title
    """
    print('##vso[task.setvariable variable=test_title]Test results '
          'for the template_database ADF Pipeline')


@pytest.mark.serial
@pytest.mark.dev
def test_set_serial_test_title():
    """Set the test title for serial run
    """
    print('##vso[task.setvariable variable=test_title]Test results '
          'for the template_database ADF Pipeline (serial)')
