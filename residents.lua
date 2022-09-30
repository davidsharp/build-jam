-- just a dictionary of characters

-- about 24 characters fit per line
-- (this could be smarter and calculated on the fly)

downstairsBloke = {
  sprite = 'bloke',
  success = 'Great work today, I look forward to seeing how you do tomorrow',
  failure = 'Hard luck, come back refreshed tomorrow',
  dialog = {
    {
      'Hey, so you must be the\nnew builder',
      'I have it here that you\'re\ncontracted for a month?',
      'Each day you\'ll need to\nbuild a new floor,',
      'And each new floor\nis a new home!',
      'But be careful!',
      'There are reports\nthat our competition',
      'has been sneaking\ndangerous material',
      'into our supplies!',
      'And if they touch\nthey could explode!',
      'Which will set back\nyour day\'s build'
    }
  }
}

residents = {
  {
    sprite = 'woman',
    request = 'Build me a home, plz',
    success = 'Wow, thanks!',
    failure = 'Dang, I\'ll have to find a home elsewhere',
    dialog = {
      {'todo'},
      {'todo'},
      {'todo'},
      {'todo'},
    }
  }
}
