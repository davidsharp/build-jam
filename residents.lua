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
      'I have it here that you\'re\ncontracted for a fortnight?',
      'Each day you\'ll need to\nbuild a new floor,',
      'And each new floor\nis a new home!',
      'Clearing lines will get\nyou closer to',
      'your goal',
      'But be careful!',
      'There are reports\nthat our competition',
      'has been sneaking\ndangerous materials',
      'into our supplies!',
      'And if they touch\nthey could explode!',
      'Which will set back\nyour day\'s build',
      'Use arrow keys to move\nleft and right',
      'And down will drop\nyour piece faster',
      'You can also use A/D\nkeys to rotate pieces',
      'But you might not be able\nif something is',
      'in the way!',
      'Your next client is on\nthe top floor',
      'Happy building!'
    }
  }
}

residents = {
  {
    sprite = 'woman',
    request = 'I\'d love for you to try\nand build me a home',
    success = 'Oh, I love it!\nThank you!',
    failure = 'Too bad, you\'ll have\nto try again tomorrow',
    dialog = {
      {'Thanks for building me\nsuch a lovely home!'}
    }
  },
  {
    sprite = 'man',
    request = 'Build me a home, plz',
    success = 'Wow, thanks!',
    failure = 'Too bad, you\'ll have\nto try again tomorrow',
    dialog = {
      {'Thanks for building me\nsuch a lovely home!'}
    }
  },
  {
    sprite = 'oldMan',
    request = 'Please build me a home,\nyoung\'un',
    success = 'I\'ve not seen a nicer home\nin all my years!',
    failure = 'Too bad, you\'ll have\nto try again tomorrow',
    dialog = {
      {'Thanks for building me\nsuch a lovely home!'}
    }
  },
}
